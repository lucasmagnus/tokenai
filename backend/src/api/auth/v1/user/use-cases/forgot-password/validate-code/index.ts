import { Request, Response } from 'express'

import { Code } from 'api/auth/entities/code'
import {
  UserForgotPasswordValidateCodeRequest,
  UserForgotPasswordValidateCodeResponse,
} from 'api/auth/v1/user/use-cases/forgot-password/validate-code/types'
import { User } from 'api/core/entities/user'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { getEpochSeconds } from 'api/core/utils/date/time'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { JsonWebToken } from 'api/core/utils/jwt/json-web-token'
import { RESET_PASSWORD_SUBJECT } from 'api/core/utils/jwt/token-types'
import { BaseException } from 'errors/exceptions/base'
import { ResourceNotFoundException } from 'errors/exceptions/resource-not-found'
import { UnauthorizedException } from 'errors/exceptions/unauthorized'
import { ErrorCode } from 'errors/types'

import { messages } from '../../../utils/constants'

const endpoint = 'forgot-password/validate-code'

export class ValidateCodeUseCase
  extends UseCaseBase<UserForgotPasswordValidateCodeResponse>
  implements IUseCaseHttp<UserForgotPasswordValidateCodeResponse>
{
  async executeHttp(
    request: Request,
    response: Response<UserForgotPasswordValidateCodeResponse>
  ): Promise<Response<UserForgotPasswordValidateCodeResponse>> {
    const result = await this.handle(request.body)
    return response.status(HttpStatusCodes.OK).json(result)
  }

  async getUser(email: string): Promise<User> {
    try {
      return await User.findByEmailOrFail(email)
    } catch (err) {
      throw new ResourceNotFoundException(messages.userNotFound)
    }
  }

  async handle(payload: UserForgotPasswordValidateCodeRequest): Promise<UserForgotPasswordValidateCodeResponse> {
    const validatedData = this.validate(payload, UserForgotPasswordValidateCodeRequest)
    const user = await this.getUser(validatedData.email)

    const userCode = await Code.findLatestFromUser(user.id)

    if (userCode && !userCode.isUsed) {
      const timeToNextTry = this.calculateTimeToNextTry(userCode)
      const exceededAttempts =
        userCode.numTries >= Number(process.env.PASSWORD_RESET_CODE_MAX_NUMBER_TRIES) &&
        timeToNextTry > getEpochSeconds()
      if (exceededAttempts) {
        throw new BaseException(
          ErrorCode.PERMISSION_ERROR,
          HttpStatusCodes.PRECONDITION_FAILED,
          messages.tooManyTriesShortTime(Math.trunc(timeToNextTry - getEpochSeconds()))
        )
      }
      userCode.numTries++
      userCode.lastTried = new Date()
      await Code.save(userCode)

      if (validatedData.code === userCode.code) {
        const token = new JsonWebToken().sign(
          {
            user_id: user.id,
            email: user.email,
            type: RESET_PASSWORD_SUBJECT,
          },
          process.env.JWT_PRIVATE_KEY + user.password
        )
        userCode.isUsed = true
        await Code.save(userCode)

        return this.validate({ data: { token }, message: messages.validCode }, UserForgotPasswordValidateCodeResponse)
      }
    }

    throw new UnauthorizedException(messages.invalidCode)
  }

  private calculateTimeToNextTry(userCode: Code): number {
    const lastTimeTriedInMilliSeconds = userCode.lastTried.getTime()
    const lastTimeTriedInSeconds = lastTimeTriedInMilliSeconds / 1000
    const timeoutTime = Number(process.env.PASSWORD_RESET_CODE_TIMEOUT_SECONDS)
    const numberOfTimesExceeded = userCode.numTries - Number(process.env.PASSWORD_RESET_CODE_MAX_NUMBER_TRIES)
    return lastTimeTriedInSeconds + timeoutTime * 2 ** numberOfTimesExceeded
  }
}
export { endpoint }

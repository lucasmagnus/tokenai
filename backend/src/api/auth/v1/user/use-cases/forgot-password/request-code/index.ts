import { Request, Response } from 'express'

import { Code, CodeTypes } from 'api/auth/entities/code'
import {
  UserForgotPasswordRequest,
  UserForgotPasswordResponse,
} from 'api/auth/v1/user/use-cases/forgot-password/request-code/types'
import { User } from 'api/core/entities/user'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { ResourceNotFoundException } from 'errors/exceptions/resource-not-found'
import { sendMessage } from 'interfaces/messenger'

import { messages } from '../../../utils/constants'

const endpoint = 'forgot-password/request-code'

export class RequestCodeUseCase
  extends UseCaseBase<UserForgotPasswordResponse>
  implements IUseCaseHttp<UserForgotPasswordResponse>
{
  async executeHttp(
    request: Request,
    response: Response<UserForgotPasswordResponse>
  ): Promise<Response<UserForgotPasswordResponse>> {
    const result = await this.handle(request.body)
    return response.status(HttpStatusCodes.OK).json(result)
  }

  async getUser(email: string): Promise<User> {
    try {
      return await User.findOneOrFail({ where: { email } })
    } catch (err) {
      throw new ResourceNotFoundException(messages.userNotFound)
    }
  }

  async handle(payload: UserForgotPasswordRequest): Promise<UserForgotPasswordResponse> {
    const validatedData = this.validate(payload, UserForgotPasswordRequest)

    const user = await this.getUser(validatedData.email)

    const resetPasswordCode = Code.create({
      user,
      type: CodeTypes.RESET_PASSWORD_REQUEST,
    })
    await Code.save(resetPasswordCode)

    await sendMessage({
      user,
      subject: 'Your reset password code',
      message: `Here is your reset password code ${resetPasswordCode.code}`,
    })
    return this.validate({ message: messages.passwordResetCodeSent }, UserForgotPasswordResponse)
  }
}
export { endpoint }

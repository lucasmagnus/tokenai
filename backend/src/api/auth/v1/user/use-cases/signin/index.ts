import { Request, Response } from 'express'

import { UserSignInRequest, UserSignInResponse } from 'api/auth/v1/user/use-cases/signin/types'
import { User } from 'api/core/entities/user'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { JsonWebToken } from 'api/core/utils/jwt/json-web-token'
import { SIGN_IN_SUBJECT } from 'api/core/utils/jwt/token-types'
import { ResourceNotFoundException } from 'errors/exceptions/resource-not-found'
import { UnauthorizedException } from 'errors/exceptions/unauthorized'

import { messages } from '../../utils/constants'

const endpoint = 'signin'

export class SigninUseCase extends UseCaseBase<UserSignInResponse> implements IUseCaseHttp<UserSignInResponse> {
  async executeHttp(request: Request, response: Response<UserSignInResponse>): Promise<Response<UserSignInResponse>> {
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

  async handle(payload: UserSignInRequest): Promise<UserSignInResponse> {
    const validatedData = this.validate(payload, UserSignInRequest)
    const user = await this.getUser(validatedData.email)

    if (await user.checkPassword(validatedData.password)) {
      const token = new JsonWebToken().sign({
        user_id: user.id,
        email: user.email,
        type: SIGN_IN_SUBJECT,
      })
      return this.validate({ data: { token }, message: messages.validUserNamePassword }, UserSignInResponse)
    }
    throw new UnauthorizedException(messages.invalidUserNamePassword)
  }
}
export { endpoint }

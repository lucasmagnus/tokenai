import { Request, Response } from 'express'

import { User } from 'api/core/entities/user'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { UserResetPasswordRequest, UserResetPasswordResponse } from './types'
import { messages } from '../../utils/constants'

const endpoint = 'reset-password'

export class ResetPasswordUseCase
  extends UseCaseBase<UserResetPasswordResponse>
  implements IUseCaseHttp<UserResetPasswordResponse>
{
  async executeHttp(
    request: Request,
    response: Response<UserResetPasswordResponse>
  ): Promise<Response<UserResetPasswordResponse>> {
    const result = await this.handle(request.body, request.user)
    return response.status(HttpStatusCodes.OK).json(result)
  }

  async handle(payload: UserResetPasswordRequest, user: User): Promise<UserResetPasswordResponse> {
    const validatedData = this.validate(payload, UserResetPasswordRequest)
    await user.setPassword(validatedData.password)
    await User.save(user)

    return this.validate({ message: messages.passwordResetSuccess }, UserResetPasswordResponse)
  }
}
export { endpoint }

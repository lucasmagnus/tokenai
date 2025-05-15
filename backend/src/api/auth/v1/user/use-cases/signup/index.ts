import { Request, Response } from 'express'

import {
  UploadProfileImageRequest,
  UserSignUpRequest,
  UserSignUpResponse,
} from 'api/auth/v1/user/use-cases/signup/payload'
import { User } from 'api/core/entities/user'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { messages } from '../../utils/constants'

const endpoint = 'signup'

export class SignUpUseCase extends UseCaseBase<UserSignUpResponse> implements IUseCaseHttp<UserSignUpResponse> {
  executeHttp = async (
    request: Request,
    response: Response<UserSignUpResponse>
  ): Promise<Response<UserSignUpResponse>> => {
    const result = await this.handle(request.body, request.file)
    return response.status(HttpStatusCodes.CREATED).json(result)
  }

  async handle(payload: UserSignUpRequest, uploadedFile?: UploadProfileImageRequest): Promise<UserSignUpResponse> {
    const validatedData = this.validate(payload, UserSignUpRequest)
    const user = User.create({
      name: validatedData.name,
      email: validatedData.email,
      password: validatedData.password,
      profile_image: uploadedFile?.filename,
    })
    const userResult = await User.save(user)
    return this.validate({ data: userResult.serialize(), message: messages.signUpSuccess }, UserSignUpResponse)
  }
}
export { endpoint }

import express from 'express'

import { resetPasswordMiddleware } from 'api/auth/middlewares/reset-password'
import { uploadImageMiddleware } from 'api/core/middlewares/upload'

import { RequestCodeUseCase, endpoint as requestCodeEndpoint } from './use-cases/forgot-password/request-code'
import { ValidateCodeUseCase, endpoint as validateCodeEndpoint } from './use-cases/forgot-password/validate-code'
import { ResetPasswordUseCase, endpoint as resetPasswordEndpoint } from './use-cases/reset-password'
import { SigninUseCase, endpoint as signInEndpoint } from './use-cases/signin'
import { SignUpUseCase, endpoint as signUpEndpoint } from './use-cases/signup'

const prefix = '/api/v1/auth'

function routes(http: express.Application): void {
  http.post(`${prefix}/${signInEndpoint}`, (req, res) => new SigninUseCase().executeHttp(req, res))
  http.post(
    `${prefix}/${signUpEndpoint}`,
    uploadImageMiddleware.single('profile_image'),
    SignUpUseCase.init().executeHttp
  )
  http.post(`${prefix}/${requestCodeEndpoint}`, async (req, res) => new RequestCodeUseCase().executeHttp(req, res))
  http.post(`${prefix}/${validateCodeEndpoint}`, async (req, res) => new ValidateCodeUseCase().executeHttp(req, res))
  http.post(`${prefix}/${resetPasswordEndpoint}`, resetPasswordMiddleware, async (req, res) =>
    new ResetPasswordUseCase().executeHttp(req, res)
  )
}

export { routes, prefix }

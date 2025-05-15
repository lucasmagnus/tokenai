import { z } from 'zod'

import { forgotPasswordType, userType } from 'api/core/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

/* Request Schema */

export const UserForgotPasswordValidateCodeRequest = forgotPasswordType
  .pick({
    code: true,
  })
  .merge(
    userType.pick({
      email: true,
    })
  )

export type UserForgotPasswordValidateCodeRequest = z.infer<typeof UserForgotPasswordValidateCodeRequest>

/* Response Schema */

export const UserForgotPasswordValidateCodeResponse = createResponseSchema(
  z.object({
    token: z.string(),
  })
)

export type UserForgotPasswordValidateCodeResponse = z.infer<typeof UserForgotPasswordValidateCodeResponse>

import { z } from 'zod'

import { userType } from 'api/core/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

/* Request Schema */

export const UserForgotPasswordRequest = userType.pick({
  email: true,
})

export type UserForgotPasswordRequest = z.infer<typeof UserForgotPasswordRequest>

/* Response Schema */

export const UserForgotPasswordResponse = createResponseSchema(z.undefined())

export type UserForgotPasswordResponse = z.infer<typeof UserForgotPasswordResponse>

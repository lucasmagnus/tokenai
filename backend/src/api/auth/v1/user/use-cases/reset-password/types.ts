import { z } from 'zod'

import { userType } from 'api/core/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

/* Request Schema */

export const UserResetPasswordRequest = userType.pick({ email: true, password: true })

export type UserResetPasswordRequest = z.infer<typeof UserResetPasswordRequest>

/* Response Schema */

export const UserResetPasswordResponse = createResponseSchema(z.undefined())

export type UserResetPasswordResponse = z.infer<typeof UserResetPasswordResponse>

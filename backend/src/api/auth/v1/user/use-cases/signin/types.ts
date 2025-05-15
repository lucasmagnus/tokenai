import { z } from 'zod'

import { userType } from 'api/core/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

/* Request Schema */

export const UserSignInRequest = userType.pick({
  email: true,
  password: true,
})

export type UserSignInRequest = z.infer<typeof UserSignInRequest>

/* Response Schema */

export const UserSignInResponse = createResponseSchema(z.object({ token: z.string() }))

export type UserSignInResponse = z.infer<typeof UserSignInResponse>

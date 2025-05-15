import { z } from 'zod'

import { userType } from 'api/core/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

/* Request Schema */

export const UserSignUpRequest = userType.pick({ password: true, name: true, email: true })

export type UserSignUpRequest = z.infer<typeof UserSignUpRequest>

export type UploadProfileImageRequest = {
  fieldname: string
  originalname: string
  encoding: string
  mimetype: string
  destination: string
  filename: string
  path: string
  size: number
  buffer?: Buffer
}

/* Response Schema */

export const UserSignUpResponse = createResponseSchema(userType.pick({ id: true, name: true, email: true }))

export type UserSignUpResponse = z.infer<typeof UserSignUpResponse>

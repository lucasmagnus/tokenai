import { z } from 'zod'

export const CreateTokenPayload = z.object({
  code: z.string(),
  amount: z.number().optional(),
  message: z.string().optional()
})

export type CreateTokenPayload = z.infer<typeof CreateTokenPayload>

export const CreateTokenResponse = z.object({
  code: z.string(),
  issuer: z.string(),
  distributor: z.string(),
  message: z.string().optional()
})

export type CreateTokenResponse = z.infer<typeof CreateTokenResponse> 
import { z } from 'zod'

export const MintTokenPayload = z.object({
  code: z.string(),
  amount: z.number(),
  message: z.string().optional()
})

export type MintTokenPayload = z.infer<typeof MintTokenPayload>

export const MintTokenResponse = z.object({
  code: z.string(),
  amount: z.number(),
  message: z.string().optional()
})

export type MintTokenResponse = z.infer<typeof MintTokenResponse> 
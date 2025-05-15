import { z } from 'zod'

export const BurnTokenPayload = z.object({
  code: z.string(),
  amount: z.number(),
  message: z.string().optional()
})

export type BurnTokenPayload = z.infer<typeof BurnTokenPayload>

export const BurnTokenResponse = z.object({
  code: z.string(),
  amount: z.number(),
  message: z.string().optional()
})

export type BurnTokenResponse = z.infer<typeof BurnTokenResponse> 
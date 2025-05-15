import { z } from 'zod'

export const PaymentPayload = z.object({
  destination: z.string(),
  amount: z.string(),
  code: z.string(),
  message: z.string().optional()
})

export type PaymentPayload = z.infer<typeof PaymentPayload>

export const PaymentResponse = z.object({
  destination: z.string(),
  amount: z.number(),
  code: z.string().optional()
})

export type PaymentResponse = z.infer<typeof PaymentResponse> 
import { z } from 'zod'

export const AIAction = z.object({
  action: z.string(),
  message: z.string().optional(),
  payload: z.any().optional(),
  wallet: z.string().optional()
})

export type AIAction = z.infer<typeof AIAction>

export interface AIActionHandler {
  canHandle(action: string): boolean
  handle(action: AIAction): Promise<any>
} 
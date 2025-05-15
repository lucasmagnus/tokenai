import { z } from 'zod'

import { createResponseSchema } from 'api/core/framework/use-case/base'

const messageType = z.object({
  message: z.string(),
  success: z.boolean(),
  data: z.any().optional(),
  chatHistory: z.array(z.object({
    content: z.string(),
    role: z.enum(['system', 'user', 'assistant'])
  })).optional()
})

export const ChatHistory = z.object({
  content: z.string(),
  role: z.enum(['system', 'user', 'assistant'])
})

export const MessageRequest = z.object({
  message: z.string(),
  chatHistory: z.array(ChatHistory).optional(),
  wallet: z.string().optional()
})

export type MessageRequest = z.infer<typeof MessageRequest>

export const MessageResponse = createResponseSchema(messageType)

export type MessageResponse = z.infer<typeof MessageResponse>

export const AIResponse = z.object({
  action: z.string().optional(),
  message: z.string().optional(),
  payload: z.any().optional()
})

export type AIResponse = z.infer<typeof AIResponse>

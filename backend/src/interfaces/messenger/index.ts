import { User } from 'api/core/entities/user'
import { logger } from 'config/logger'
interface SendMessageParams {
  user: User
  subject: string
  message: string
}

export const sendMessage = async ({ user, subject, message }: SendMessageParams): Promise<void> => {
  logger.info(`\n user: ${user.email}\n subject: ${subject}\n message: ${message}\n`)
  await Promise.resolve()
}

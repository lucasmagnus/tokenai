import { AIAction, AIActionHandler } from './types'
import { CreateTokenAction } from './token/create'
import { MintTokenAction } from './token/mint'
import { BurnTokenAction } from './token/burn'
import { PaymentAction } from './transactions/payment'

export class AIActionFactory {
  private static handlers: AIActionHandler[] = [
    new CreateTokenAction(),
    new MintTokenAction(),
    new BurnTokenAction(),
    new PaymentAction()
  ]

  static async handle(action: AIAction): Promise<any> {
    const handler = this.handlers.find(h => h.canHandle(action.action))
    if (!handler) {
      throw new Error(`No handler found for action: ${action.action}`)
    }
    return handler.handle(action)
  }
} 
import { AIAction, AIActionHandler } from '../../types'
import { PaymentPayload, PaymentResponse } from './types'
import { CONFIG, KEYS } from 'api/asset/utils/constants'
import { Contact } from 'api/contacts/entities/contact'
import {
  Horizon,
  Asset,
  Operation,
  TransactionBuilder,
  Networks,
} from 'stellar-sdk'

export class PaymentAction implements AIActionHandler {
  canHandle(action: string): boolean {
    return action === 'send_payment'
  }

  async handle(action: AIAction): Promise<any> {
    console.log('payload: ', action.payload)
    const { destination, amount, code, message } = action.payload as PaymentPayload

    if (!action?.wallet) {
      throw new Error('Invalid contact wallet')
    }

    const server = new Horizon.Server(CONFIG.horizonUrl)
    const account = await server.loadAccount(action.wallet)

    const asset = new Asset(code, KEYS.issuerPK)

    const contactWallet = await Contact.findOne({
      where: { name: destination },
    })

    if (!contactWallet?.wallet) {
      throw new Error('Invalid contact wallet')
    }

    const paymentOperation = Operation.payment({
      destination: contactWallet?.wallet,
      asset,
      amount: amount.toString(),
    })

    const tx = new TransactionBuilder(account, {
      fee: (await server.fetchBaseFee()).toString(),
      networkPassphrase:
        CONFIG.network.name === 'testnet' ? Networks.TESTNET : Networks.PUBLIC,
    })
      .addOperation(paymentOperation)
      .setTimeout(180)
      .build()

    const xdr = tx.toXDR()

    console.log({
      action: action,
      xdr: xdr
    })
    return {
      action: action,
      message: message,
      xdr: xdr
    }
  }
}

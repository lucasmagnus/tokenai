import { StellarPlus } from 'stellar-plus'

import { AIAction, AIActionHandler } from '../../types'
import { MintTokenPayload, MintTokenResponse } from './types'
import { CONFIG, KEYS } from 'api/asset/utils/constants'

export class MintTokenAction implements AIActionHandler {
  canHandle(action: string): boolean {
    return action === 'mint_token'
  }

  async handle(action: AIAction): Promise<MintTokenResponse> {
    const payload = action.payload as MintTokenPayload

    const issuerAccount = new StellarPlus.Account.DefaultAccountHandler({
      secretKey: KEYS.issuerSK,
      networkConfig: CONFIG.network,
    })
    const distributionAccount = new StellarPlus.Account.DefaultAccountHandler({
      secretKey: KEYS.distributorSK,
      networkConfig: CONFIG.network,
    })

    const token = new StellarPlus.Asset.ClassicAssetHandler({
      code: payload.code,
      networkConfig: CONFIG.network,
      issuerAccount,
    })

    const txInvocationConfig = {
      header: {
        source: distributionAccount.getPublicKey(),
        fee: '1000',
        timeout: 45,
      },
      signers: [distributionAccount, issuerAccount],
    }

    await token.mint({
      to: distributionAccount.getPublicKey(),
      amount: payload.amount,
      ...txInvocationConfig,
    })

    return {
      code: token.code,
      amount: payload.amount,
      message: payload.message,
    }
  }
}

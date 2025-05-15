import { StellarPlus } from 'stellar-plus'

import { AIAction, AIActionHandler } from '../../types'
import { BurnTokenPayload, BurnTokenResponse } from './types'
import { CONFIG, KEYS } from 'api/asset/utils/constants'

export class BurnTokenAction implements AIActionHandler {
  canHandle(action: string): boolean {
    return action === 'burn_token'
  }

  async handle(action: AIAction): Promise<BurnTokenResponse> {
    const payload = action.payload as BurnTokenPayload

    const issuerAccount = new StellarPlus.Account.DefaultAccountHandler({secretKey: KEYS.issuerSK, networkConfig: CONFIG.network })
    const distributionAccount = new StellarPlus.Account.DefaultAccountHandler({ secretKey: KEYS.distributorSK, networkConfig: CONFIG.network  })

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

    await token.burn({
      from: distributionAccount.getPublicKey(),
      amount: payload.amount,
      ...txInvocationConfig,
    })

    return {
      code: token.code,
      amount: payload.amount,
      message: payload.message
    }
  }
} 
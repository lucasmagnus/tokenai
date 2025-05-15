import { StellarPlus } from 'stellar-plus'
import { Asset } from 'api/asset/entities/asset'

import { AIAction, AIActionHandler } from '../../types'
import { CreateTokenPayload, CreateTokenResponse } from './types'
import { CONFIG, KEYS } from 'api/asset/utils/constants'

export class CreateTokenAction implements AIActionHandler {
  canHandle(action: string): boolean {
    return action === 'create_token'
  }

  async handle(action: AIAction): Promise<CreateTokenResponse> {
    const payload = action.payload as CreateTokenPayload

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

    await token.addTrustline({
      to: distributionAccount.getPublicKey(),
      ...txInvocationConfig,
    })

    const asset = new Asset()
    asset.code = token.code
    asset.issuerWallet = issuerAccount.getPublicKey()
    asset.authorizationRequired = false
    asset.authorizationRevocable = false
    asset.clawbackEnabled = false
    asset.authorizationImmutable = false
    await asset.save()

    return {
      code: token.code,
      issuer: issuerAccount.getPublicKey(),
      distributor: distributionAccount.getPublicKey(),
      message: payload.message
    }
  }
} 
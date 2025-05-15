import { Request, Response } from "express";

import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";

import { CreateAssetRequest, CreateAssetResponse } from "./payload";
import { messages } from "../../utils/constants";
import { StellarPlus } from "stellar-plus";
import { Asset } from "api/asset/entities/asset";
import { CONFIG, KEYS } from "api/asset/utils/constants";

export class CreateAssetUseCase
  extends UseCaseBase<CreateAssetResponse>
  implements IUseCaseHttp<CreateAssetResponse>
{
  executeHttp = async (
    request: Request,
    response: Response<CreateAssetResponse>
  ): Promise<Response<CreateAssetResponse>> => {
    const result = await this.handle(request.body);
    return response.status(HttpStatusCodes.CREATED).json(result);
  };

  async handle(payload: CreateAssetRequest): Promise<any> {
    const { code, flags } = this.validate(payload, CreateAssetRequest)

    const issuerAccount = new StellarPlus.Account.DefaultAccountHandler({
      networkConfig: CONFIG.network,
      secretKey: KEYS.issuerSK
    });

    const distributionAccount = new StellarPlus.Account.DefaultAccountHandler({
      networkConfig: CONFIG.network,
      secretKey: KEYS.distributorSK
    });

    const token = new StellarPlus.Asset.ClassicAssetHandler({
      code: code,
      networkConfig: CONFIG.network,
      issuerAccount,
    });

    const txInvocationConfig = {
      header: {
        source: distributionAccount.getPublicKey(),
        fee: "1000",
        timeout: 45,
      },
      signers: [distributionAccount],
    };

    await token.addTrustline({
      to: distributionAccount.getPublicKey(),
      ...txInvocationConfig,
    });

    await token.setFlags({
      controlFlags: {
        authorizationRequired: flags?.authorizationRequired ?? false,
        authorizationRevocable: flags?.authorizationRevocable ?? false,
        clawbackEnabled: flags?.clawbackEnabled ?? false,
        authorizationImmutable: flags?.authorizationImmutable ?? false,
      },
      ...txInvocationConfig,
    });

    const asset = new Asset();
    asset.code = code;
    asset.issuerWallet = issuerAccount.getPublicKey();
    asset.authorizationRequired = flags?.authorizationRequired ?? false;
    asset.authorizationRevocable = flags?.authorizationRevocable ?? false;
    asset.clawbackEnabled = flags?.clawbackEnabled ?? false;
    asset.authorizationImmutable = flags?.authorizationImmutable ?? false;
    
    await asset.save();
    
    return { data: asset, message: messages.ASSET_CREATED }
  }
}

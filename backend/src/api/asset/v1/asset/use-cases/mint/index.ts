import { Request, Response } from "express";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { StellarPlus } from "stellar-plus";
import { CONFIG, KEYS } from "api/asset/utils/constants";
import { z } from "zod";

const MintAssetRequest = z.object({
  code: z.string(),
  amount: z.number(),
});

export type MintAssetRequest = z.infer<typeof MintAssetRequest>;

export class MintAssetUseCase
  extends UseCaseBase<{ message: string; data: any }>
  implements IUseCaseHttp<{ message: string; data: any }>
{
  executeHttp = async (
    request: Request,
    response: Response<{ message: string; data: any }>
  ): Promise<Response<{ message: string; data: any }>> => {
    const result = await this.handle(request.body);
    return response.status(HttpStatusCodes.OK).json(result);
  };

  async handle(payload: MintAssetRequest): Promise<{ message: string; data: any }> {
    console.log('entrou 1');
    const { code, amount } = this.validate(payload, MintAssetRequest);

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

    await token.mint({
      to: distributionAccount.getPublicKey(),
      amount: amount,
      ...txInvocationConfig,
    });

    console.log('entrou 10')

    return {
      message: "Asset minted successfully",
      data: { code, amount }
    };
  }
} 
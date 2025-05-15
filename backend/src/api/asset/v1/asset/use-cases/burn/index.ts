import { Request, Response } from "express";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { StellarPlus } from "stellar-plus";
import { CONFIG, KEYS } from "api/asset/utils/constants";
import { z } from "zod";

const BurnAssetRequest = z.object({
  code: z.string(),
  amount: z.number(),
});

export type BurnAssetRequest = z.infer<typeof BurnAssetRequest>;

export class BurnAssetUseCase
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

  async handle(payload: BurnAssetRequest): Promise<{ message: string; data: any }> {
    const { code, amount } = this.validate(payload, BurnAssetRequest);

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

    await token.burn({
      from: distributionAccount.getPublicKey(),
      amount: amount,
      ...txInvocationConfig,
    });

    return {
      message: "Asset burned successfully",
      data: { code, amount }
    };
  }
} 
import { Request, Response } from "express"

import { Asset } from "api/asset/entities/asset"
import { UseCaseBase } from "api/core/framework/use-case/base"
import { IUseCaseHttp } from "api/core/framework/use-case/http"
import { HttpStatusCodes } from "api/core/utils/http/status-code"

import { ListAssetsResponse } from "./payload"
import { CONFIG, KEYS } from "api/asset/utils/constants"
import { HorizonHandler } from "stellar-plus/lib/stellar-plus"

export class ListAssetsUseCase
  extends UseCaseBase<ListAssetsResponse>
  implements IUseCaseHttp<ListAssetsResponse>
{
  executeHttp = async (
    request: Request,
    response: Response<ListAssetsResponse>
  ): Promise<Response<ListAssetsResponse>> => {
    const result = await this.handle(request.params)
    return response.status(HttpStatusCodes.OK).json(result)
  }

  async handle(params: any): Promise<any> {
    const issuerPK = params?.issuer
    const assets = await Asset.find({ order: { createdAt: "DESC" } })

    const horizonHandler = new HorizonHandler(CONFIG.network)
    const issuerAccount = await horizonHandler.loadAccount(issuerPK)
    const balances = issuerAccount.balances

    const assetsWithBalances = assets.map((asset) => {
      const matchingBalance = balances.find(
        (b) =>
          (b as any).asset_code === asset.code &&
          (b as any).asset_issuer === asset.issuerWallet
      )

      return {
        ...asset,
        balance: matchingBalance?.balance,
      }
    })

    return assetsWithBalances
  }
}

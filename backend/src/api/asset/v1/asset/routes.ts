import express from 'express'

import { CreateAssetUseCase } from './use-cases/create'
import { ListAssetsUseCase } from './use-cases/list'
import { ListTransactionsUseCase } from './use-cases/list-transactions'
import { MintAssetUseCase } from './use-cases/mint'
import { BurnAssetUseCase } from './use-cases/burn'
import { PaymentUseCase } from './use-cases/payment'

const assetRoutesPrefix = '/api/v1/asset'

function routes(http: express.Application): void {
  http.post(
    `${assetRoutesPrefix}`,
    CreateAssetUseCase.init().executeHttp
  )
  http.get(`${assetRoutesPrefix}/list/:issuer`, ListAssetsUseCase.init().executeHttp)
  http.get(`${assetRoutesPrefix}/transactions/:issuer`, ListTransactionsUseCase.init().executeHttp)
  http.post(
    `${assetRoutesPrefix}/mint`,
    MintAssetUseCase.init().executeHttp
  )
  http.post(
    `${assetRoutesPrefix}/burn`,
    BurnAssetUseCase.init().executeHttp
  )
  http.post(
    `${assetRoutesPrefix}/payment`,
    PaymentUseCase.init().executeHttp
  )
}

export { routes, assetRoutesPrefix }

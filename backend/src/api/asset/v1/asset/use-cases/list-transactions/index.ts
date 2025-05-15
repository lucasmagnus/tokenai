import { Request, Response } from 'express'
import { UseCaseBase } from 'api/core/framework/use-case/base'
import { IUseCaseHttp } from 'api/core/framework/use-case/http'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { StellarPlus } from 'stellar-plus'
import { CONFIG, KEYS } from 'api/asset/utils/constants'
import { Transaction } from '../../types/transaction'

export class ListTransactionsUseCase
  extends UseCaseBase<{ message: string; data: Transaction[] }>
  implements IUseCaseHttp<{ message: string; data: Transaction[] }>
{
  executeHttp = async (
    request: Request,
    response: Response<{ message: string; data: Transaction[] }>
  ): Promise<Response<{ message: string; data: Transaction[] }>> => {
    const result = await this.handle(request.params)
    return response.status(HttpStatusCodes.OK).json(result)
  }

  async handle(params: any): Promise<{ message: string; data: Transaction[] }> {
    const horizonHandler = new StellarPlus.HorizonHandler(CONFIG.network)
    const issuerPK = params?.issuer
    const account = await horizonHandler.loadAccount(issuerPK)
    const operations = await account.operations()

    let allTransactions = [...operations.records]
    let currentPage = operations

    while (currentPage.records.length > 0) {
      const nextPage = await currentPage.next()
      allTransactions = [...allTransactions, ...nextPage.records]
      currentPage = nextPage
    }

    const mappedTransactions = allTransactions
      .map((record: any) => ({
        id: record.id,
        type: record.type,
        createdAt: record.created_at,
        account: record.to,
        amount: record.amount,
        assetCode: record.asset_code,
        assetIssuer: record.asset_issuer,
        isDebit: record.from === issuerPK,
      }))
      .filter(transaction => transaction.type === 'payment')

    return {
      message: 'Transactions retrieved successfully',
      data: mappedTransactions,
    }
  }
}

import { Request, Response } from "express";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { createResponseSchema } from "api/core/framework/use-case/base";
import { z } from "zod";
import { Keypair, Asset, Operation, TransactionBuilder, Networks, Horizon } from "stellar-sdk";
import { CONFIG, KEYS } from "api/asset/utils/constants";

const paymentSchema = z.object({
  userWallet: z.string(),
  contactWallet: z.string(),
  amount: z.string(),
  issuer: z.string(),
  code: z.string(),
});

const paymentResponse = createResponseSchema(z.object({
  xdr: z.string(),
}));

export type PaymentResponse = z.infer<typeof paymentResponse>;

export class PaymentUseCase
  extends UseCaseBase<PaymentResponse>
  implements IUseCaseHttp<PaymentResponse>
{
  executeHttp = async (
    request: Request,
    response: Response<PaymentResponse>
  ): Promise<Response<PaymentResponse>> => {
    const result = await this.handle(request);
    return response.status(HttpStatusCodes.OK).json(result);
  };

  async handle(request: Request): Promise<PaymentResponse> {
    const { userWallet, contactWallet, amount, issuer, code } = paymentSchema.parse(request.body);

    const server = new Horizon.Server(CONFIG.horizonUrl);
    const account = await server.loadAccount(userWallet);

    const asset = new Asset(code, issuer);

    const paymentOperation = Operation.payment({
      destination: contactWallet,
      asset,
      amount,
    });

    const tx = new TransactionBuilder(account, {
      fee: (await server.fetchBaseFee()).toString(),
      networkPassphrase: CONFIG.network.name === "testnet"
        ? Networks.TESTNET
        : Networks.PUBLIC,
    })
      .addOperation(paymentOperation)
      .setTimeout(180)
      .build();

    const xdr = tx.toXDR();

    return {
      message: 'Success',
      data : {
        xdr: xdr
      },
    };
  }
}

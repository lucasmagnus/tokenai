import { Request, Response } from "express";
import { Contact } from "api/contacts/entities/contact";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { createResponseSchema } from 'api/core/framework/use-case/base';
import { contactType } from '../../utils/constants';
import { z } from 'zod';

const createContactSchema = z.object({
  name: z.string(),
  wallet: z.string(),
  userWallet: z.string()
});

const createContactResponse = createResponseSchema(contactType);
export type CreateContactResponse = z.infer<typeof createContactResponse>;

export class CreateContactUseCase
  extends UseCaseBase<CreateContactResponse>
  implements IUseCaseHttp<CreateContactResponse>
{
  executeHttp = async (
    request: Request,
    response: Response
  ): Promise<Response> => {
    const result = await this.handle(request);
    return response.status(HttpStatusCodes.CREATED).json(result);
  };

  async handle(request: Request): Promise<any> {
    const payload = this.validate(request.body, createContactSchema);
    const contact = Contact.create({
      name: payload.name,
      wallet: payload.wallet,
      userWallet: payload.userWallet,
    });
    await contact.save();
    return contact;
  }
} 
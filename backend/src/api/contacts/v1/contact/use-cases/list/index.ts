import { Request, Response } from "express";
import { Contact } from "api/contacts/entities/contact";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { createResponseSchema } from 'api/core/framework/use-case/base';
import { contactType } from '../../utils/constants';
import { z } from 'zod';

const contactListType = createResponseSchema(
  contactType.array()
);
export type ListContactsResponse = z.infer<typeof contactListType>;

export class ListContactsUseCase
  extends UseCaseBase<ListContactsResponse>
  implements IUseCaseHttp<ListContactsResponse>
{
  executeHttp = async (
    request: Request,
    response: Response
  ): Promise<Response> => {
    const result = await this.handle(request);
    return response.status(HttpStatusCodes.OK).json(result);
  };

  async handle(request: Request): Promise<any> {
    const userWallet = request.params?.wallet;
    const contacts = await Contact.find({ where: { userWallet }, order: { createdAt: 'DESC' } });
    return contacts;
  }
} 
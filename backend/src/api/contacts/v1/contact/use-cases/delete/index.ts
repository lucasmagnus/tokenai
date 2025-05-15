import { Request, Response } from "express";
import { Contact } from "api/contacts/entities/contact";
import { UseCaseBase } from "api/core/framework/use-case/base";
import { IUseCaseHttp } from "api/core/framework/use-case/http";
import { HttpStatusCodes } from "api/core/utils/http/status-code";
import { createResponseSchema } from 'api/core/framework/use-case/base';
import { z } from 'zod';

const deleteContactResponse = createResponseSchema(z.void());
export type DeleteContactResponse = z.infer<typeof deleteContactResponse>;

export class DeleteContactUseCase
  extends UseCaseBase<DeleteContactResponse>
  implements IUseCaseHttp<DeleteContactResponse>
{
  executeHttp = async (
    request: Request,
    response: Response
  ): Promise<Response> => {
    const result = await this.handle(request);
    return response.status(HttpStatusCodes.OK).json(result);
  };

  async handle(request: Request): Promise<DeleteContactResponse> {
    const { id } = request.params;
    const userEmail = request.user?.email;
    const contact = await Contact.findOne({ where: { id, userEmail } });
    if (!contact) {
      throw new Error('Contact not found');
    }
    await contact.remove();
    return { message: 'Contact deleted' };
  }
} 
import { ZodError, ZodType, z } from 'zod'

import { ZodValidationException } from 'errors/exceptions/zod-validation'

type ResponseSchema<T extends z.ZodTypeAny> = z.ZodObject<{
  message: z.ZodString
  data: T
}>

export function createResponseSchema<T extends z.ZodTypeAny>(dataSchema: T): ResponseSchema<T> {
  return z.object({
    message: z.string(),
    data: dataSchema,
  })
}

export const BaseResponseSchema = createResponseSchema(z.any())
export type BaseResponseSchema = z.infer<typeof BaseResponseSchema>

export interface IUseCaseBase<Response extends BaseResponseSchema = BaseResponseSchema> {
  handle(...params: unknown[]): Promise<Response>
}

export abstract class UseCaseBase<UseCaseResponse extends BaseResponseSchema = BaseResponseSchema>
  implements IUseCaseBase
{
  abstract handle(...params: unknown[]): Promise<UseCaseResponse>

  protected validate<T extends ZodType>(payload: unknown, schema: T): z.infer<typeof schema> {
    const request: { success: boolean; error?: ZodError; data?: typeof payload } = schema.safeParse(payload)
    if (!request.success && request.error instanceof ZodError) {
      throw new ZodValidationException(request.error)
    }
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return request.data as z.infer<typeof schema>
  }

  static init<T = UseCaseBase>(this: { new (): T }): T {
    return new this()
  }
}

import { FindManyOptions } from 'typeorm'
import { z } from 'zod'

export const PaginationSchema = z
  .object({
    page: z.coerce.number().min(1).optional(),
    limit: z.coerce.number().min(10).max(100).optional(),
  })
  .optional()

export const paginationQueryStringProperties = {
  page: { type: ['string', 'number'], default: 1 },
  limit: { type: ['string', 'number'], default: 20 },
}

export type PaginationSchema = z.infer<typeof PaginationSchema>

/**
 * @template T
 * @param {T} responseSchema - This object data will be encapsulated in an array
 */

type PaginationResponse<T extends z.ZodTypeAny> = z.ZodObject<{
  total: z.ZodNumber
  current_page: z.ZodNumber
  data: z.ZodArray<T>
  message: z.ZodString
}>
export const createPaginationResponseSchema = <T extends z.ZodTypeAny>(responseSchema: T): PaginationResponse<T> =>
  z.object({
    total: z.number(),
    current_page: z.number(),
    data: z.array(responseSchema),
    message: z.string(),
  })

export type PaginationWithDataResponseProperty<T = unknown> = {
  total: number
  current_page: number
  data: T[]
  message: string
}

type PaginationQuery = Pick<FindManyOptions, 'skip' | 'take'>

type PaginationParams = {
  page: number
} & PaginationQuery

const parsePaginationParams = (query: PaginationSchema): PaginationParams => {
  const page = Number(query?.page) || 1
  const limit = Number(query?.limit) || 20

  return {
    page,
    skip: (page - 1) * limit,
    take: limit,
  }
}

type PaginationPropsType = {
  pagination: PaginationQuery
  getDataWithPagination: <T>(data: T[], total: number, message: string) => PaginationWithDataResponseProperty<T>
}

export const getPaginationProps = (query: PaginationSchema): PaginationPropsType => {
  const { page, skip, take } = parsePaginationParams(query)
  type PaginatedData<T> = { total: number; current_page: number; data: T[]; message: string }
  const getDataWithPagination = <T>(data: T[], total: number, message: string): PaginatedData<T> => {
    return {
      total,
      current_page: page,
      data,
      message,
    }
  }

  return {
    pagination: { skip, take },
    getDataWithPagination,
  }
}

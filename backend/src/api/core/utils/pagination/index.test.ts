import { ZodError } from 'zod'

import { PaginationSchema, PaginationWithDataResponseProperty, getPaginationProps } from '.'

describe('pagination', () => {
  describe('PaginationSchema', () => {
    it('should parse valid pagination query string params', () => {
      const validQueryParams = {
        page: '2',
        limit: '50',
      }

      expect(() => PaginationSchema.parse(validQueryParams)).not.toThrow()
    })

    it('should parse pagination query string params with missing optional params', () => {
      const validQueryParams = {
        page: '2',
      }

      expect(() => PaginationSchema.parse(validQueryParams)).not.toThrow()
    })

    it('should throw an error for invalid pagination query string params', () => {
      const invalidQueryParams = {
        page: 'invalid',
        limit: '101',
      }

      expect(() => PaginationSchema.parse(invalidQueryParams)).toThrow(ZodError)
    })
  })

  describe('getPaginationProps', () => {
    it('should return pagination options with skip and take', () => {
      const query = {
        page: 2,
        limit: 50,
      }

      const paginationProps = getPaginationProps({
        page: query.page,
        limit: query.limit,
      })

      expect(paginationProps.pagination).toEqual({
        skip: 50,
        take: 50,
      })
    })

    it('should return data with pagination', () => {
      const query = {
        page: '2',
        limit: '50',
      }

      const data = [1, 2, 3, 4, 5]
      const total = 100
      const message = 'Pagination test message'

      const paginationProps = getPaginationProps({
        page: Number(query.page),
        limit: Number(query.limit),
      })

      const expected: PaginationWithDataResponseProperty<number> = {
        total,
        current_page: 2,
        data,
        message,
      }

      expect(paginationProps.getDataWithPagination(data, total, message)).toEqual(expected)
    })
  })
})

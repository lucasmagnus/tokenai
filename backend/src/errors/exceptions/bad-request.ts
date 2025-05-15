import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { BaseException } from './base'
import { ErrorCode } from '../types'

export class BadRequestException extends BaseException {
  constructor(details: string) {
    super(ErrorCode.BAD_REQUEST, HttpStatusCodes.BAD_REQUEST, details)
  }
}

import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { BaseException } from './base'
import { ErrorCode } from '../types'

export class UnauthorizedException extends BaseException {
  constructor(details: string) {
    super(ErrorCode.PERMISSION_ERROR, HttpStatusCodes.UNAUTHORIZED, details)
  }
}

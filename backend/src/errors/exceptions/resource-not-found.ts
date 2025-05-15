import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { BaseException } from './base'
import { ErrorCode } from '../types'

export class ResourceNotFoundException extends BaseException {
  constructor(details: string) {
    super(ErrorCode.RESOURCE_NOT_FOUND, HttpStatusCodes.NOT_FOUND, details)
  }
}

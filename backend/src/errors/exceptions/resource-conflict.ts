import { HttpStatusCodes } from 'api/core/utils/http/status-code'

import { BaseException } from './base'
import { ErrorCode } from '../types'

export class ResourceConflictedException extends BaseException {
  constructor(details: string) {
    super(ErrorCode.RESOURCE_CONFLICTED, HttpStatusCodes.CONFLICT, details)
  }
}

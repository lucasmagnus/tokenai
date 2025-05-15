import { badRequest } from 'api/core/utils/docs/error.docs'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { zodToSchema } from 'api/core/utils/zod'

import { UserForgotPasswordRequest, UserForgotPasswordResponse } from './types'
import { ACCOUNT_TAG } from '../../../utils/constants'

export default {
  post: {
    tags: [ACCOUNT_TAG],
    summary: 'Forgot password - Request code',
    responses: {
      [HttpStatusCodes.OK]: {
        type: 'object',
        content: {
          'application/json': {
            schema: zodToSchema(UserForgotPasswordResponse),
          },
        },
      },
      ...badRequest,
    },
    requestBody: {
      content: {
        'application/json': {
          schema: zodToSchema(UserForgotPasswordRequest),
        },
      },
    },
  },
}

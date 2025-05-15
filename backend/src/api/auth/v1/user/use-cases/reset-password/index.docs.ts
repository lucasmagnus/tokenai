import { badRequest } from 'api/core/utils/docs/error.docs'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { zodToSchema } from 'api/core/utils/zod'

import { UserResetPasswordRequest, UserResetPasswordResponse } from './types'
import { ACCOUNT_TAG } from '../../utils/constants'

export default {
  post: {
    tags: [ACCOUNT_TAG],
    summary: 'Reset password',
    security: [
      {
        bearerAuth: [],
      },
    ],
    responses: {
      [HttpStatusCodes.OK]: {
        type: 'object',
        content: {
          'application/json': {
            schema: zodToSchema(UserResetPasswordResponse),
          },
        },
      },
      ...badRequest,
    },
    requestBody: {
      content: {
        'application/json': {
          schema: zodToSchema(UserResetPasswordRequest),
        },
      },
    },
  },
}

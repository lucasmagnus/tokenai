import { badRequest, unauthorized } from 'api/core/utils/docs/error.docs'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { zodToSchema } from 'api/core/utils/zod'

import { UserSignInRequest, UserSignInResponse } from './types'
import { ACCOUNT_TAG } from '../../utils/constants'

export default {
  post: {
    tags: [ACCOUNT_TAG],
    summary: 'Sign in',
    responses: {
      [HttpStatusCodes.OK]: {
        type: 'object',
        content: {
          'application/json': {
            schema: zodToSchema(UserSignInResponse),
          },
        },
      },
      ...badRequest,
      ...unauthorized,
    },
    requestBody: {
      content: {
        'application/json': {
          schema: zodToSchema(UserSignInRequest),
        },
      },
    },
  },
}

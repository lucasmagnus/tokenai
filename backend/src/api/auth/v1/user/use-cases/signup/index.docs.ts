import { badRequest, conflict } from 'api/core/utils/docs/error.docs'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { zodToSchema } from 'api/core/utils/zod'

import { UserSignUpRequest, UserSignUpResponse } from './payload'
import { ACCOUNT_TAG } from '../../utils/constants'

export default {
  post: {
    tags: [ACCOUNT_TAG],
    summary: 'Sign up',
    responses: {
      [HttpStatusCodes.CREATED]: {
        type: 'object',
        content: {
          'application/json': {
            schema: zodToSchema(UserSignUpResponse),
          },
        },
      },
      ...badRequest,
      ...conflict,
    },
    requestBody: {
      content: {
        'application/json': {
          schema: zodToSchema(UserSignUpRequest),
        },
      },
    },
  },
}

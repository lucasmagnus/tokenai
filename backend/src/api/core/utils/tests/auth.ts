import { User } from 'api/core/entities/user'

import { JsonWebToken } from '../jwt/json-web-token'
import { SIGN_IN_SUBJECT } from '../jwt/token-types'

export const getUserSigninToken = (user: User): string => {
  return new JsonWebToken().sign({
    user_id: user.id,
    email: user.email,
    type: SIGN_IN_SUBJECT,
  })
}

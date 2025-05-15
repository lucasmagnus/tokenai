import { NextFunction, Request, Response } from 'express'

import { messages } from 'api/auth/utils/constants'
import { messages as coreMessages } from 'api/core/constants'
import { JsonWebToken } from 'api/core/utils/jwt/json-web-token'
import { SIGN_IN_SUBJECT } from 'api/core/utils/jwt/token-types'
import { UnauthorizedException } from 'errors/exceptions/unauthorized'

import { User } from '../entities/user'

export type JWTTokenData = {
  email: string
  user_id: number
  type: string
}

export async function authenticationMiddleware(req: Request, res: Response, next: NextFunction): Promise<void> {
  let token, data
  try {
    const authorization = req.headers.authorization
    if (!authorization) {
      throw new UnauthorizedException(coreMessages.INVALID_CREDENTIALS)
    }
    token = authorization.replace('Bearer ', '')
    data = new JsonWebToken().verify(token) as JWTTokenData
  } catch (error) {
    throw new UnauthorizedException(coreMessages.INVALID_CREDENTIALS)
  }
  if (data['type'] !== SIGN_IN_SUBJECT) throw new UnauthorizedException(coreMessages.INVALID_CREDENTIALS)

  try {
    const user: User = await User.findOneOrFail({ where: { email: data['email'] } })
    req.user = user
    return next()
  } catch (error) {
    throw new UnauthorizedException(messages.INVALID_JWT_USER)
  }
}

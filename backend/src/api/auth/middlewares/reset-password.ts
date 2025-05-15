import { NextFunction, Request, Response } from 'express'

import { messages as coreMessages } from 'api/core/constants'
import { User } from 'api/core/entities/user'
import { JsonWebToken } from 'api/core/utils/jwt/json-web-token'
import { RESET_PASSWORD_SUBJECT } from 'api/core/utils/jwt/token-types'
import { UnauthorizedException } from 'errors/exceptions/unauthorized'

import { messages } from '../v1/user/utils/constants'

export type JWTTokenData = {
  email: string
  user_id: string
  type: string
}

export async function resetPasswordMiddleware(req: Request, res: Response, next: NextFunction): Promise<void> {
  let token, user: User, data

  try {
    user = await User.findOneOrFail({ where: { email: req.body.email as string } })
  } catch (error) {
    throw new UnauthorizedException(messages.invalidJwtUser)
  }
  const authorization = req.headers.authorization
  if (!authorization) {
    throw new UnauthorizedException(coreMessages.INVALID_CREDENTIALS)
  }
  try {
    token = authorization.replace('Bearer ', '')
    data = new JsonWebToken().verify(token, process.env.JWT_PRIVATE_KEY + user.password) as JWTTokenData
  } catch (error) {
    throw new UnauthorizedException(coreMessages.INVALID_CREDENTIALS)
  }

  if (user.email !== data['email'] || user.id !== data['user_id'])
    throw new UnauthorizedException(messages.resetTokenInvalidUser)

  if (data['type'] !== RESET_PASSWORD_SUBJECT) throw new UnauthorizedException(messages.invalidJwtType)

  req.user = user
  return next()
}

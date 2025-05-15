import { User } from 'api/core/entities/user'
import 'express'

declare global {
  namespace Express {
    interface Request {
      user: User
    }
  }
}

import express from 'express'

import { routes as userRoutes } from './v1/user/routes'

function routes(http: express.Application): void {
  userRoutes(http)
}

export { routes }

import express from 'express'

import { routes as assetRoutes } from './v1/asset/routes'

function routes(http: express.Application): void {
  assetRoutes(http)
}

export { routes }

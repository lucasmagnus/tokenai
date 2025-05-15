import express, { NextFunction, Request, Response, Router } from 'express'

import { routes as authenticationRoutes } from 'api/auth/routes'
import { routes as assetRoutes } from 'api/asset/routes'
import { routes as chatRoutes } from 'api/chat/routes'
import { routes as contactsRoutes } from 'api/contacts/routes'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'

function routes(http: express.Application): void {
  http.get('/health-check', (req, res) => {
    res.status(HttpStatusCodes.OK).send()
  })
  authenticationRoutes(http)
  assetRoutes(http)
  chatRoutes(http)
  contactsRoutes(http)
}

export { routes, Request, Response, Router, NextFunction }

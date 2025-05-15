import express from 'express'

import { routes as contactsRoutes } from './v1/contact/routes'

function routes(http: express.Application): void {
  contactsRoutes(http)
}

export { routes }

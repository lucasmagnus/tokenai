import * as Sentry from '@sentry/node'
import bodyParser from 'body-parser'
import cors from 'cors'
import express from 'express'
import 'express-async-errors'
import 'reflect-metadata'
import swaggerUI from 'swagger-ui-express'

import { isTestEnv } from 'config/env-utils'
import { logger } from 'config/logger'
import { swaggerDefinition } from 'interfaces/express/openapi'

const application: express.Application = express()

// MIDDLEWARES
//application.use(Sentry.Handlers.requestHandler())
application.use(cors())
application.use(bodyParser.urlencoded({ extended: true }))
application.use(bodyParser.json())

// DOCS
const swaggerOptions = {
  swaggerOptions: {
    url: '/docs/swagger.json',
  },
}
application.get('/docs/swagger.json', (req, res) => res.json(swaggerDefinition))
application.use('/docs', swaggerUI.serveFiles(undefined, swaggerOptions), swaggerUI.setup(undefined, swaggerOptions))

if (!isTestEnv()) {
  logger.info(`Loaded => express`)
}

export default application

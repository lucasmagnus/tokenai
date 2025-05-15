import { ApolloServer } from 'apollo-server-express'
import express from 'express'
import { Server } from 'socket.io'

import { exceptionMiddleware } from 'api/core/middlewares/exception'
import { routes } from 'api/core/routes'
import { initializeDatabase } from 'config/database'
import { isTestEnv } from 'config/env-utils'
import { logger } from 'config/logger'
import { resolvers } from 'interfaces/graphql/resolvers'
import { typeDefs } from 'interfaces/graphql/type-defs'
import { fineTuneModel, fineTuneStatus, uploadTrainingData } from 'api/core/services/ai'

let app: Application | null = null

class Application {
  public project: string
  public server: ApolloServer
  public http: express.Application
  public io: Server

  constructor() {

    // SETTINGS
    this.project = 'project_name'
    this.config().then(async () => {
      // INTERFACES
      const { http, socketIO } = await import('interfaces')
      this.http = http

      // Sentry - Init before all apps
      this.io = socketIO

      // API ROUTES - graphQL is on /graphql (no auth)
      routes(http)

      // CREATE APOLLO SERVER
      this.server = new ApolloServer({
        typeDefs,
        resolvers,
      })
      await this.server.start()

      // APPLY EXPRESS
      this.server.applyMiddleware({
        app: http,
      })

      // Error handling
      http.use(exceptionMiddleware)

      if (!isTestEnv()) {
        logger.info('ApolloServer is running 🚀')
      }
    })
  }

  private async config(): Promise<void> {
    await import('config/env')
    await initializeDatabase()
  }
}

function getServer(): Application {
  if (app !== null) return app

  app = new Application()
  return app
}

export default getServer()

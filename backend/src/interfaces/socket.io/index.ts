import http from 'http'

import { Server } from 'socket.io'

import { isTestEnv } from 'config/env-utils'
import { logger } from 'config/logger'

export default (server: http.Server): Server => new Server(server)

if (!isTestEnv()) {
  logger.info(`Loaded => socket.io`)
}

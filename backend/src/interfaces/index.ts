import * as HTTPServer from 'http'

import SocketIO from 'socket.io'

import { isTestEnv } from 'config/env-utils'
import http from 'interfaces/express'
import socket from 'interfaces/socket.io'

const server: HTTPServer.Server = HTTPServer.createServer(http)
const socketIO: SocketIO.Server = socket(server)

if (!isTestEnv()) {
  server.listen(process.env.PORT)
}

//AWS LOAD BALANCE FIX
server.keepAliveTimeout = 61 * 1000
server.headersTimeout = 65 * 1000

export { http, socketIO }

import express from 'express'
import multer from 'multer';

import { SendMessageUseCase, endpoint as sendMessageEndpoint } from './v1/ai/usecase/send-message'

const prefix = '/api/v1/ai'

const upload = multer({ dest: './uploads/' });

function routes(http: express.Application): void {
  //------ Routes with Middleware ------
  http.post(`${prefix}/${sendMessageEndpoint}`, (req, res) =>
    new SendMessageUseCase().executeHttp(req, res)
  )
}

export { routes, prefix }

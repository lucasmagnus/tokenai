import express from 'express'
import { CreateContactUseCase, DeleteContactUseCase, ListContactsUseCase } from './use-cases'

const contactsRoutesPrefix = '/api/v1/contacts'

function routes(http: express.Application): void {
  http.get(
    `${contactsRoutesPrefix}/:wallet`,
    ListContactsUseCase.init().executeHttp
  )
  http.post(`${contactsRoutesPrefix}`, CreateContactUseCase.init().executeHttp)
  http.delete(`${contactsRoutesPrefix}/:id`, DeleteContactUseCase.init().executeHttp)
}

export { routes, contactsRoutesPrefix }

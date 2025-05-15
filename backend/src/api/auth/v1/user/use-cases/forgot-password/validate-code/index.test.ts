import request from 'supertest'

import { Code } from 'api/auth/entities/code'
import { prefix as authPrefix } from 'api/auth/v1/user/routes'
import { RequestCodeUseCase } from 'api/auth/v1/user/use-cases/forgot-password/request-code'
import { endpoint as validateCodeEndpoint } from 'api/auth/v1/user/use-cases/forgot-password/validate-code'
import { User } from 'api/core/entities/user'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { userFactory } from 'api/core/utils/tests/fixtures'
import server from 'app'

let user: User
const requestEndpoint = `${authPrefix}/${validateCodeEndpoint}`
let code: Code | null

beforeEach(async () => {
  user = await userFactory({})
  await new RequestCodeUseCase().handle({ email: user.email })
  code = await Code.findOne({
    where: { user: { id: user.id }, isUsed: false },
  })
})

describe('Validate Code Use Case Tests', () => {
  it('Should send password reset token with correct code', async () => {
    const response = await request(server.http).post(requestEndpoint).send({
      email: user.email,
      code: code?.code,
    })

    expect(response.statusCode).toBe(HttpStatusCodes.OK)
    expect(response.body.data.token).not.toBeUndefined()
  })

  it('Should not send token with wrong code', async () => {
    const countCode = Number(code?.code) - 1
    const response = await request(server.http)
      .post(requestEndpoint)
      .send({
        email: user.email,
        code: String(countCode),
      })

    expect(response.statusCode).toBe(HttpStatusCodes.UNAUTHORIZED)
    expect(response.body.token).toBeUndefined()
  })

  it('Should block requests for this user after configured number of tries', async () => {
    const countCode = Number(code?.code) - 1
    const serverToCall = await request(server.http)
    let response
    for (let i = 0; i <= Number(process.env.PASSWORD_RESET_CODE_MAX_NUMBER_TRIES); i++) {
      response = await serverToCall.post(requestEndpoint).send({
        email: user.email,
        code: String(countCode),
      })
    }
    expect(response?.statusCode).toBe(HttpStatusCodes.PRECONDITION_FAILED)
    expect(response?.body.token).toBeUndefined()
  })
})

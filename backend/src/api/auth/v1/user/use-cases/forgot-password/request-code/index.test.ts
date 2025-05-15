import request from 'supertest'

import { Code } from 'api/auth/entities/code'
import { prefix as authPrefix } from 'api/auth/v1/user/routes'
import { endpoint as requestCodeEndpoint } from 'api/auth/v1/user/use-cases/forgot-password/request-code'
import { User } from 'api/core/entities/user'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { userFactory } from 'api/core/utils/tests/fixtures'
import server from 'app'

let user: User
const requestEndpoint = `${authPrefix}/${requestCodeEndpoint}`

beforeEach(async () => {
  user = await userFactory({})
})

describe('Request Code Use Case Tests', () => {
  it('Should create a password reset code for an existing user', async () => {
    const response = await request(server.http).post(requestEndpoint).send({
      email: user.email,
    })

    expect(response.statusCode).toBe(HttpStatusCodes.OK)
    expect(
      await Code.findOne({
        where: { user: { id: user.id }, isUsed: false },
      })
    ).not.toBeUndefined()
  })

  it('Should not create a password reset code for a nonexistent user', async () => {
    const response = await request(server.http)
      .post(requestEndpoint)
      .send({
        email: user.email + '.br',
      })

    expect(response.statusCode).toBe(HttpStatusCodes.NOT_FOUND)
    expect(
      await Code.findOne({
        where: { user: { id: user.id }, isUsed: false },
      })
    ).toBeNull()
  })
})

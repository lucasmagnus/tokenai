import request from 'supertest'

import { prefix as authPrefix } from 'api/auth/v1/user/routes'
import { endpoint as signInEndpoint } from 'api/auth/v1/user/use-cases/signin'
import { User } from 'api/core/entities/user'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import { userFactory } from 'api/core/utils/tests/fixtures'
import server from 'app'

let user: User
const requestEndpoint = `${authPrefix}/${signInEndpoint}`
const password = 'Secret$123'

beforeEach(async () => {
  user = await userFactory({ password })
})

describe('SignIn Use Case Tests', () => {
  it('Should authenticate user and return token ', async () => {
    const response = await request(server.http).post(requestEndpoint).send({
      email: user.email,
      password: password,
    })
    expect(response.statusCode).toBe(HttpStatusCodes.OK)
    expect(response.body.data).toHaveProperty('token')
  })

  it('Should not authenticate user with wrong password ', async () => {
    const response = await request(server.http)
      .post(requestEndpoint)
      .send({
        email: user.email,
        password: password + '$',
      })

    expect(response.statusCode).toBe(HttpStatusCodes.UNAUTHORIZED)
    expect(response.body).not.toHaveProperty('token')
  })

  it('Should not authenticate with missing fields ', async () => {
    const response = await request(server.http).post(requestEndpoint).send({
      email: user.email,
    })

    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body).not.toHaveProperty('token')
  })
})

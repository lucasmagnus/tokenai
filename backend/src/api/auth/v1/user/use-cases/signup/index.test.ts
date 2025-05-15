import { faker } from '@faker-js/faker'
import superTest from 'supertest'

import { prefix as authPrefix } from 'api/auth/v1/user/routes'
import { endpoint as signUpEndpoint } from 'api/auth/v1/user/use-cases/signup'
import { User } from 'api/core/entities/user'
import { HttpStatusCodes } from 'api/core/utils/http/status-code'
import server from 'app'

const makeRequest = ({
  request,
  payload,
}: {
  request: superTest.SuperTest<superTest.Test>
  payload: object
}): superTest.Test => request.post(`${authPrefix}/${signUpEndpoint}`).send(payload)

describe('SignUp Use Case Tests', () => {
  let userData: { name: string; email: string; password: string }
  let request: superTest.SuperTest<superTest.Test>

  beforeEach(async () => {
    userData = {
      name: faker.person.fullName(),
      email: faker.internet.email(),
      password: 'Secret$123',
    }
  })

  beforeAll(() => {
    request = superTest(server.http)
  })

  it('Should register user and return created status and registered user info inside the body ', async () => {
    const response = await makeRequest({ request, payload: userData })
    expect(await User.count()).toBe(1)
    const user = (await User.find())[0]
    expect(user.email).toBe(userData.email)
    expect(user.name).toBe(userData.name)
    expect(response.statusCode).toBe(HttpStatusCodes.CREATED)
    expect(response.body.data).toStrictEqual({
      id: user.id,
      name: user.name,
      email: user.email,
    })
  })

  it('Should not register with invalid email  ', async () => {
    const response = await makeRequest({ request, payload: { ...userData, email: userData.email.replace('@', '') } })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
  })

  it('Should not register with missing email ', async () => {
    const response = await makeRequest({ request, payload: { name: userData.name, password: userData.password } })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
  })

  it('Should not register with missing password ', async () => {
    const response = await makeRequest({ request, payload: { name: userData.name, email: userData.email } })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.password[0].message).toBe('Required')
  })

  it('Should not register with shorter password than 8 characters', async () => {
    const response = await makeRequest({ request, payload: { ...userData, password: userData.password.slice(0, 7) } })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.password[0].message).toBe('Invalid')
  })

  it('Should not register with password without special character', async () => {
    const response = await makeRequest({
      request,
      payload: { ...userData, password: userData.password.replace('$', '') },
    })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.password[0].message).toBe('Invalid')
  })

  it('Should not register with password without digits', async () => {
    const response = await makeRequest({
      request,
      payload: { ...userData, password: userData.password.replace('123', 'abc') },
    })

    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.password[0].message).toBe('Invalid')
  })

  it('Should not register with password without upper case letter', async () => {
    const response = await makeRequest({
      request,
      payload: { ...userData, password: userData.password.replace('S', 's') },
    })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.password[0].message).toBe('Invalid')
  })

  it('Should not register with missing name ', async () => {
    const response = await makeRequest({ request, payload: { password: userData.password, email: userData.email } })
    expect(response.statusCode).toBe(HttpStatusCodes.BAD_REQUEST)
    expect(response.body.fields.name[0].message).toBe('Required')
  })

  it('Should not register with profile image exceeding size limit', async () => {
    const largeImage = Buffer.alloc(1024 * 1024 * 6, 'a')
    const response = await makeRequest({ request, payload: { ...userData, profile_image: largeImage } })
    expect(response.statusCode).toBe(HttpStatusCodes.INTERNAL_SERVER_ERROR)
  })

  it('Should register with missing profile image ', async () => {
    const response = await makeRequest({ request, payload: { ...userData, profile_image: null } })
    expect(response.statusCode).toBe(HttpStatusCodes.CREATED)
  })

  it('Should register with valid profile image format ', async () => {
    const file = {
      fieldname: 'profile_image',
      originalname: 'profile_image.jpeg',
      encoding: '7bit',
      mimetype: 'image/jpeg',
      destination: '/path/public/uploads',
      filename: '1711635669010-profile_image.txt',
      path: '/path/1711635669010-profile_image.jpeg',
      size: 5051,
    }

    const response = await makeRequest({ request, payload: { ...userData, profile_image: file } })
    expect(response.statusCode).toBe(HttpStatusCodes.CREATED)
  })
})

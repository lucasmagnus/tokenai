import { compare } from 'api/core/utils/crypto'
import { userFactory } from 'api/core/utils/tests/fixtures'

import { User } from '.'

let user: User
const password = 'Pa$$word123'
beforeEach(async () => {
  user = await userFactory({ password })
})

describe('User entity tests', () => {
  it('Should hash password on save and replace with hashed one', async () => {
    await User.save(user)
    expect(await compare(password, user.password)).toBe(true)
  })

  it('Should fill in ID, createdAt and updatedAt values after saving', async () => {
    await User.save(user)
    expect(user.id).not.toBeUndefined()
    expect(user.createdAt).not.toBeUndefined()
    expect(user.updatedAt).not.toBeUndefined()
  })
})

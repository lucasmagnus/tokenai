import { faker } from '@faker-js/faker'

import { User } from 'api/core/entities/user'

type CreateUserArgs = {
  name?: string
  email?: string
  password?: string
}

export const userFactory = async ({ name, email, password }: CreateUserArgs): Promise<User> => {
  const user = User.create({
    name: name ?? faker.person.fullName(),
    email: email ?? faker.internet.email(),
    password: password ?? faker.internet.password(),
  })
  return await User.save(user)
}

import { IsEmail } from 'class-validator'

import { BeforeInsert, Column, Entity, FindOneOptions, ModelBase, SerializeProps } from 'api/core/framework/orm'
import { compare, encrypt } from 'api/core/utils/crypto'

@Entity()
export class User extends ModelBase {
  @Column()
  name: string

  @Column({ unique: true })
  @IsEmail()
  email: string

  @Column()
  password: string

  @Column({ nullable: true })
  profile_image: string

  serialize(extraProps?: SerializeProps): SerializeProps {
    return {
      name: this.name,
      email: this.email,
      profile_image: this.profile_image,
      ...super.serialize(extraProps),
    }
  }

  @BeforeInsert()
  async hashPassword(): Promise<User> {
    return this.password ? this.setPassword(this.password) : this
  }

  async setPassword(password: string): Promise<User> {
    this.password = await encrypt({ data: password, strength: 8 })
    return this
  }

  async checkPassword(password: string): Promise<boolean> {
    return await compare(password, this.password)
  }

  static findByEmail(email: string, relations?: FindOneOptions<User>['relations']): Promise<User | null> {
    return User.findOne({ where: { email }, relations })
  }

  static async findByEmailOrFail(email: string, relations?: FindOneOptions<User>['relations']): Promise<User> {
    const user = await this.findByEmail(email, relations)
    if (!user) {
      throw User.notFoundError()
    }
    return user
  }
}

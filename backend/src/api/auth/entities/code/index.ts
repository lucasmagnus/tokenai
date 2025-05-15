import * as crypto from 'crypto'

import { User } from 'api/core/entities/user'
import { BeforeInsert, Column, Entity, JoinColumn, ManyToOne, ModelBase } from 'api/core/framework/orm'

export enum CodeTypes {
  RESET_PASSWORD_REQUEST = 'RESET_PASSWORD_REQUEST',
}

@Entity()
export class Code extends ModelBase {
  @ManyToOne(() => User)
  @JoinColumn()
  user: User

  @Column()
  code: string

  @Column()
  type: CodeTypes

  @Column({ default: false })
  isUsed: boolean

  @Column({ default: () => 'CURRENT_TIMESTAMP' })
  lastTried: Date

  @Column({ default: 0 })
  numTries: number

  @BeforeInsert()
  async setCode(): Promise<void> {
    this.code = String(crypto.randomInt(0, 1000000)).padStart(6, '0')
  }

  static async findLatestFromUser(userId: string): Promise<Code | null> {
    return await this.findOne({
      where: { user: { id: userId }, type: CodeTypes.RESET_PASSWORD_REQUEST },
      order: { createdAt: 'DESC' },
    })
  }
}

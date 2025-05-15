import 'config/env'
import path from 'path'

import { DataSource, DataSourceOptions } from 'typeorm'
import { SnakeNamingStrategy } from 'typeorm-naming-strategies'

import { entities } from 'api/core/entities'

const rootDir = ['production', 'staging'].includes(process.env.NODE_ENV ?? '') ? `${__dirname}/../..` : 'src'

export const AppDataSource = new DataSource({
  name: 'default',
  type: process.env.DATABASE_TYPE as 'mariadb' | 'mysql' | 'postgres' | 'sqlite',
  host: process.env.DATABASE_HOST,
  port: Number(process.env.DATABASE_PORT),
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  migrations: [path.join(rootDir, 'api/*/migrations/*.{js,ts}')],
  entities,
  namingStrategy: new SnakeNamingStrategy(),
} as DataSourceOptions)

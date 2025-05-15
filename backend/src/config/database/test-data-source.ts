import { DataSource } from 'typeorm'

import 'config/env'
import { entities } from 'api/core/entities'

// Be careful to not use this in production with a real database
export const TestDataSource = new DataSource({
  name: 'test',
  type: process.env.DATABASE_TYPE as 'mariadb' | 'mysql' | 'postgres' | 'sqlite',
  host: process.env.DATABASE_HOST,
  port: Number(process.env.DATABASE_PORT),
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  dropSchema: true,
  migrationsRun: true,
  synchronize: true,
  // create databases by each Jest worker to make parallel testing possible
  database: 'test' + process.env.JEST_WORKER_ID,
  migrations: ['src/api/**/migrations/*.{js,ts}'],
  entities,
})

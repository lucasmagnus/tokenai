import { promisify } from 'util'

import mysql from 'mysql'

import { AppDataSource, initializeDatabase } from 'config/database'

const upDb = async (): Promise<void> => {
  const conn = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
  })
  await promisify(conn.connect).bind(conn)()
  await promisify(conn.query).bind(conn)(`DROP DATABASE IF EXISTS ${AppDataSource.options.database}`)
  await promisify(conn.query).bind(conn)(`CREATE DATABASE ${AppDataSource.options.database}`)
  await promisify(conn.end).bind(conn)()

  await initializeDatabase()
}

const downDb = async (): Promise<void> => {
  /*
    AppDataSource.dropDatabase() was not really dropping the database,
    so we connect manually and drop it directly via driver
   */
  const conn = mysql.createConnection({
    host: process.env.DATABASE_HOST,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
  })
  await promisify(conn.connect).bind(conn)()
  await promisify(conn.query).bind(conn)(`DROP DATABASE IF EXISTS ${AppDataSource.options.database}`)
  await promisify(conn.end).bind(conn)()

  await AppDataSource.destroy()
}

const clearDb = async (): Promise<void> => {
  await AppDataSource.synchronize(true)
}

beforeAll(async () => {
  await upDb()
})

afterEach(async () => {
  await clearDb()
})

afterAll(async () => {
  await downDb()
})

jest.setTimeout(10000)
process.env.DEBUG = 'false'

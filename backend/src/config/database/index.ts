import { isTestEnv } from 'config/env-utils'
import { LogTypes, logger } from 'config/logger'

import { AppDataSource as MainDataSource } from './data-source'
import { TestDataSource } from './test-data-source'

const AppDataSource = isTestEnv() ? TestDataSource : MainDataSource

const databaseConnectionLog = (logType: LogTypes, message: string, err?: unknown): void => {
  if (!isTestEnv()) {
    const mergingObject = { message, err }
    logger[logType](mergingObject, message)
  }
}

const initializeDatabase = async (): Promise<void> => {
  try {
    await AppDataSource.initialize()
    databaseConnectionLog(LogTypes.Info, 'Initialized database')
  } catch (err) {
    databaseConnectionLog(LogTypes.Error, 'Error initializing database', err)
  }
}

export { AppDataSource, initializeDatabase }

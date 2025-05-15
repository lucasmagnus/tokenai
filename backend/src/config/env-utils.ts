export const envTypes = {
  DEV: 'development',
  TEST: 'test',
}

export function isDevEnv(): boolean {
  return process.env.NODE_ENV === envTypes.DEV
}

export function isTestEnv(): boolean {
  return process.env.NODE_ENV === envTypes.TEST
}

export const rootDir = process.env.DEPLOY_STAGE === 'local' ? 'src/' : 'dist/'

export const codeExtension = process.env.DEPLOY_STAGE === 'local' ? '.ts' : '.js'

import path from 'path'

import { z } from 'zod'

import { password } from 'api/auth/v1/user/utils/regex'

export const PROJECT_ROOT_FOLDER = path.resolve(__dirname, '../../..')

export const UPLOADS_PATH = path.join(PROJECT_ROOT_FOLDER, 'public/uploads')

export const messages = {
  INVALID_CREDENTIALS: 'Invalid credentials',
}

export const userType = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string().email(),
  password: z.string().regex(password),
})

export const forgotPasswordType = z.object({
  code: z.string(),
})

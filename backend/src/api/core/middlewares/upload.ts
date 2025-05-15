import * as path from 'path'

import multer, { StorageEngine } from 'multer'
import multerS3 from 'multer-s3'

import { isDevEnv, isTestEnv } from 'config/env-utils'

import { messages } from '../../auth/utils/constants'
import { UPLOADS_PATH } from '../constants'
import { createS3Client } from '../utils/aws/s3'

const generateFileName = (file: Express.Multer.File): string => {
  return `${new Date().getTime().toString()}-${file.fieldname}${path.extname(file.originalname)}`
}

const storageLocal = (): StorageEngine =>
  multer.diskStorage({
    destination: UPLOADS_PATH,
    filename(_, file: Express.Multer.File, fn: (error: Error | null, filename: string) => void): void {
      fn(null, generateFileName(file))
    },
  })

const createStorageS3 = (): StorageEngine =>
  multerS3({
    s3: createS3Client(),
    bucket: process.env.AWS_S3_BUCKET_NAME || 'uploads',
    metadata: function (_req, file, callback) {
      callback(null, { fieldName: file.fieldname })
    },
    key: function (_req, file, callback) {
      callback(null, generateFileName(file))
    },
  })

export const uploadImageMiddleware = multer({
  storage: isDevEnv() || isTestEnv() ? storageLocal() : createStorageS3(),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter(_req, file, callback) {
    const isValidExtension: boolean =
      ['.png', '.jpg', '.jpeg'].indexOf(path.extname(file.originalname).toLowerCase()) >= 0
    const isValidMimeType: boolean = ['image/png', 'image/jpg', 'image/jpeg'].indexOf(file.mimetype) >= 0

    if (isValidExtension && isValidMimeType) {
      return callback(null, true)
    }

    callback(new Error(messages.INVALID_IMG_TYPE))
  },
})

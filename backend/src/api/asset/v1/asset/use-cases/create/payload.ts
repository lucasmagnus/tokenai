import { z } from 'zod'

import { createResponseSchema } from 'api/core/framework/use-case/base'

import { assetType, assetFlagsSchema } from '../../utils/constants'

/* Request Schema */

export const CreateAssetRequest = z.object({
  code: z.string(),
  issuer: z.string(),
  flags: assetFlagsSchema.optional(),
})

export type CreateAssetRequest = z.infer<typeof CreateAssetRequest>

/* Response Schema */

export const CreateAssetResponse = createResponseSchema(assetType)

export type CreateAssetResponse = z.infer<typeof CreateAssetResponse>

import { z } from 'zod'

import { assetType } from '../../utils/constants'
import { createResponseSchema } from 'api/core/framework/use-case/base'

// Create a schema for a list of assets
const assetListType = z.array(assetType)

// Create a response schema that includes a list of assets
export const ListAssetsResponse = createResponseSchema(assetListType)

export type ListAssetsResponse = z.infer<typeof ListAssetsResponse>

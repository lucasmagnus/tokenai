import { z } from 'zod'

export const messages = {
  ASSET_CREATED: 'Asset Created!'
}

export const assetFlagsSchema = z.object({
  authorizationRequired: z.boolean().optional(),
  authorizationRevocable: z.boolean().optional(),
  clawbackEnabled: z.boolean().optional(),
  authorizationImmutable: z.boolean().optional(),
})

export const assetType = z.object({
  id: z.string().uuid(),
  code: z.string(),
  issuerWallet: z.string(),
  authorizationRequired: z.boolean(),
  authorizationRevocable: z.boolean(),
  clawbackEnabled: z.boolean(),
  authorizationImmutable: z.boolean(),
  totalSupply: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
})


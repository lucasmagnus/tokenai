import { z } from "zod";

export const transactionType = z.object({
  id: z.string(),
  type: z.string(),
  createdAt: z.string(),
  account: z.string(),
  amount: z.string().optional(),
  assetCode: z.string().optional(),
  assetIssuer: z.string().optional(),
});

export type Transaction = z.infer<typeof transactionType>; 
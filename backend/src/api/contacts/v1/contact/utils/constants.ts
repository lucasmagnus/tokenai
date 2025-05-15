import { z } from 'zod'

export const messages = {
  CONTACT_CREATED: 'Contact Created!',
  CONTACT_DELETED: 'Contact Deleted!',
}

export const contactType = z.object({
  id: z.string().uuid(),
  name: z.string(),
  wallet: z.string(),
  userEmail: z.string(),
  createdAt: z.date(),
  updatedAt: z.date(),
}) 
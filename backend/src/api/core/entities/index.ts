import { entities as authEntities } from 'api/auth/entities'
import { entities as assetEntities } from 'api/asset/entities'
import { entities as contactsEntities } from 'api/contacts/entities'

import { User } from './user'

export const entities = [...authEntities, ...assetEntities, ...contactsEntities, User]

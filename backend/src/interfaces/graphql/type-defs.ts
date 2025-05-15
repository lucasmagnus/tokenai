import { gql } from 'apollo-server-express'

const typeDefs = gql`
  type HealthCheck {
    message: String
  }

  type Query {
    health_check: HealthCheck
  }
`
export { typeDefs }

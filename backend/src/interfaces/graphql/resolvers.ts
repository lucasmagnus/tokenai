const resolvers = {
  Query: {
    health_check: (): { message: string } => ({ message: 'GraphQL working!!' }),
  },
}

export { resolvers }

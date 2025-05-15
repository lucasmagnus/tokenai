FROM node:20.16-bullseye-slim AS base
WORKDIR /app
RUN apt-get update && apt-get install -y make
COPY package*.json Makefile ./
RUN make clean-setup-dev
COPY . .

FROM base AS local
ENV DEPLOY_STAGE=local
ENTRYPOINT [ "./entrypoint.sh" ]

FROM base AS builder
RUN make build

FROM node:20.16-bullseye-slim AS remote
WORKDIR /app
ENV DEPLOY_STAGE=remote
RUN apt-get update && apt-get install -y make
COPY package*.json Makefile entrypoint.sh ./
RUN make clean-setup
COPY --from=builder /app/dist ./dist
ENTRYPOINT [ "./entrypoint.sh" ]

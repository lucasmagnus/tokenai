#!/bin/bash
set -e

make migration-run

if [[ $DEPLOY_STAGE = "local" ]] ; then
  make setup-dev
  make dev
else
  make start
fi
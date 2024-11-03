#!/bin/bash
set -e
DATABASE_URL="postgres://$PGUSER:$PGPASSWORD@$PGHOST:$PGPORT/$PGDATABASE"
mkdir -p out
pg_dump $DATABASE_URL > ./out/dump.dmp
npx node-pg-migrate up

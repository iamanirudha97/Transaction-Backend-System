#!/bin/sh 

set -e 

echo "run db migrations"
migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@"
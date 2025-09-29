#!/bin/sh
set -e

python /app/main.py &

exec nginx -g "daemon off;"

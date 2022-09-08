#!/bin/bash
set -e

. ./script/load-app-configuration.sh

printf "\nDOCKER ENTRYPOINT: Running database migrations ...\n"

bundle exec rake db:prepare

printf "\nDOCKER ENTRYPOINT: Running database migrations COMPLETE\n\n"

exec "$@"

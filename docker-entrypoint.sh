#!/usr/bin/env sh
set -eu

envsubst '${REGION} ${TABLE} ${REALM} ${CACHE_FOLDER} ${CACHE_DURATION}' < /aws.pam > /etc/pam.d/aws

# get folder configs
FOLDERS=$(input=$PATHS /create-path-config.sh)
envsubst '${UPSTREAM} ${FOLDERS}' < /apache.conf > /etc/apache2/sites-available/000-default.conf

exec "$@"

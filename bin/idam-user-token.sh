#!/bin/bash
## Usage: ./idam-user-token.sh [role] [user_id]
##
## Options:
##    - role: Role assigned to user in generated token. Default to `ccd-import`.
##    - user_id: ID assigned to user in generated token. Default to `1`.
##
## Returns a valid IDAM user token for the given role and user_id.

source ../.env

code=$(curl ${CURL_OPTS} -u "${IMPORTER_USERNAME}:${IMPORTER_PASSWORD}" -XPOST "${IDAM_URI}/oauth2/authorize?redirect_uri=${REDIRECT_URI}&response_type=code&client_id=${CLIENT_ID}" -d "" | jq -r .code)

curl ${CURL_OPTS} -H "Content-Type: application/x-www-form-urlencoded" -u "${CLIENT_ID}:${CLIENT_SECRET}" -XPOST "${IDAM_URI}/oauth2/token?code=${code}&redirect_uri=${REDIRECT_URI}&grant_type=authorization_code" -d "" | jq -r .access_token

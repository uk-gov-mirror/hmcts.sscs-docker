#!/bin/bash

source .env

set -e

echo "curl ${CURL_OPTS} -u \"${IMPORTER_USERNAME}:${IMPORTER_PASSWORD}\" -XPOST \"${IDAM_URI}/oauth2/authorize?redirect_uri=${REDIRECT_URI}&response_type=code&client_id=${CLIENT_ID}\""

code=$(curl ${CURL_OPTS} -u "${IMPORTER_USERNAME}:${IMPORTER_PASSWORD}" -XPOST "${IDAM_URI}/oauth2/authorize?redirect_uri=${REDIRECT_URI}&response_type=code&client_id=${CLIENT_ID}" -d "" | jq -r .code)

echo "Code: ${code}"

curl ${CURL_OPTS} -H "Content-Type: application/x-www-form-urlencoded" -u "${CLIENT_ID}:${CLIENT_SECRET}" -XPOST "${IDAM_URI}/oauth2/token?code=${code}&redirect_uri=${REDIRECT_URI}&grant_type=authorization_code" -d "" | jq -r .access_token

curl  -u "ccd-importer@server.net:Password12" -XPOST "http://localhost:5000/oauth2/authorize?redirect_uri=http://localhost:3000/receiver&response_type=code&client_id=ccd_gateway"

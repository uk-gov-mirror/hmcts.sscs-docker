#!/bin/bash
## Usage: ./idam-user-token.sh [role] [user_id]
##
## Options:
##    - role: Role assigned to user in generated token. Default to `ccd-import`.
##    - user_id: ID assigned to user in generated token. Default to `1`.
##
## Returns a valid IDAM user token for the given role and user_id.

source .env

./create-import-user.sh

echo "Getting user_token from idam"
userToken=$(./idam-authenticate.sh ${IMPORTER_USERNAME} ${IMPORTER_PASSWORD} ${IDAM_URI} ${REDIRECT_URI} ${CLIENT_ID} ${CLIENT_SECRET})

echo "Token: ${userToken}"

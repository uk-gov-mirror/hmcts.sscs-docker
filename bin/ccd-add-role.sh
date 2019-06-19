#!/bin/bash
## Usage: ./ccd-add-role.sh role [classification]
##
## Options:
##    - role: Name of the role. Must be an existing IDAM role.
##    - classification: Classification granted to the role; one of `PUBLIC`,
##        `PRIVATE` or `RESTRICTED`. Default to `PUBLIC`.
##
## Add support for an IDAM role in CCD.

./create-import-user.sh

role=$1

if [ -z "$role" ]
  then
    echo "Usage: ./ccd-add-role.sh role [classification]"
    exit 1
fi

binFolder=$(dirname "$0")

echo $binFolder

userToken="$(${binFolder}/idam-user-token.sh)"
serviceToken="$(${binFolder}/idam-service-token.sh)"

echo "User token: $userToken"
echo "Service token: $serviceToken"

echo

curl -XPUT \
  http://localhost:4451/api/user-role \
  -H "Authorization: Bearer ${userToken}" \
  -H "ServiceAuthorization: Bearer ${serviceToken}" \
  -H "Content-Type: application/json" \
  -d '{"role":"'${role}'","security_classification":"PUBLIC"}'

echo

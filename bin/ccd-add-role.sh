#!/bin/bash

role=$1

if [ -z "$role" ]
  then
    echo "Usage: ./ccd-add-role.sh role [classification]"
    exit 1
fi

binFolder=$(dirname "$0")

userToken="$(${binFolder}/idam-user-token.sh)"
serviceToken="$(${binFolder}/idam-service-token.sh)"

echo

curl -XPUT \
  http://localhost:4451/api/user-role \
  -H "Authorization: Bearer ${userToken}" \
  -H "ServiceAuthorization: Bearer ${serviceToken}" \
  -H "Content-Type: application/json" \
  -d '{"role":"'${role}'","security_classification":"PUBLIC"}'

echo

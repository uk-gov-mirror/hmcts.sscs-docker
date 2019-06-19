#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage: ./ccd-import-definition.sh path_to_definition"
    exit 1
elif [ ! -f "$1" ]
  then
    echo "File not found: $1"
    exit 1
fi

binFolder=$(dirname "$0")

userToken="$(${binFolder}/idam-user-token.sh)"
serviceToken="$(${binFolder}/idam-service-token.sh)"

curl --silent \
  http://localhost:4451/import \
  -H "Authorization: Bearer ${userToken}" \
  -H "ServiceAuthorization: Bearer ${serviceToken}" \
  -F file="@$1"

echo

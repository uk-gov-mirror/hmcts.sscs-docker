#!/bin/bash
## Usage: ./idam-service-token.sh [microservice_name]
##
## Options:
##    - microservice_name: Name of the microservice. Default to `ccd_gw`.
##
## Returns a valid IDAM service token for the given microservice.

microservice="${1:-ccd_gw}"

echo "Getting service_token from s2s"
serviceToken=$(curl --fail --silent --show-error -X POST ${AUTH_PROVIDER_BASE_URL}/testing-support/lease -d "{\"microservice\":\"${MICROSERVICE}\"}" -H 'content-type: application/json')

curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"microservice":"'${microservice}'"}' \
  http://localhost:5000/testing-support/lease

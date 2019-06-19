#!/bin/bash
## Usage: ./idam-service-token.sh [microservice_name]
##
## Options:
##    - microservice_name: Name of the microservice. Default to `ccd_gw`.
##
## Returns a valid IDAM service token for the given microservice.

source .env

curl --fail --silent --show-error -X POST http://localhost:4502/testing-support/lease -d "{\"microservice\":\"sscs\"}" -H 'content-type: application/json'

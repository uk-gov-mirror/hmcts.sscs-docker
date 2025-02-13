#!/bin/sh

## Usage: ./import-local-definition.sh
##
## Import a local version of the AAT definition into CCD's definition store. The path to the definition is set in field CCD_CASE_DEFINITION_XLS in the .env file.
##
## Prerequisites:
##  - Microservice `ccd_gw` must be authorised to call service `ccd-definition-store-api`

source .env

if [ ! -f $CCD_CASE_DEFINITION_XLS ]; then
  echo "=========================================================================================="
  echo "CCD definition not found."
  echo "Please check the CCD_CASE_DEFINITION_XLS value in  your .env file"
  echo "Location is currently set to $CCD_CASE_DEFINITION_XLS"
  echo "=========================================================================================="
  exit
fi

cd ../sscs-ccd-definitions/benefit
docker build -t hmctspublic.azurecr.io/sscs/ccd-definition-importer-benefit:dev -f ../docker/importer.Dockerfile .
cd ../
./bin/create-xlsx.sh benefit dev aat
cd ../sscs-docker
./bin/ccd-import-definition.sh $CCD_CASE_DEFINITION_XLS

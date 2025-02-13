#!/bin/bash

source ./bin/set-environment-variables.sh
source .env

./bin/idam-create-caseworker.sh ccd-import ccd.docker.default@hmcts.net Pa55word11 Default CCD_Docker
./bin/add-sscs-ccd-roles.sh
./bin/idam-create-caseworker.sh caseworker-sscs,caseworker,caseworker-sscs-superuser local.test@example.com
./bin/idam-create-caseworker.sh caseworker-sscs-systemupdate,caseworker-sscs,caseworker system.update@hmcts.net

./bin/idam-create-caseworker.sh caseworker,caseworker-sscs,caseworker-sscs-dwpresponsewriter dwpuser@example.com Pa55word11 DWP user
./bin/idam-create-caseworker.sh caseworker,caseworker-sscs,caseworker-sscs-judge judge@example.com Pa55word11 Judge user

./bin/idam-create-caseworker.sh citizen sscs-citizen2@hmcts.net

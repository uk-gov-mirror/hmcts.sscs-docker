#!/bin/bash

set -e

source .env

command -v az >/dev/null 2>&1 || {
    echo "=========================================================================================="
    echo >&2 "Please install Azure CLI - instructions in README.md"
    echo "=========================================================================================="
    exit 1
}

command -v docker-compose >/dev/null 2>&1 || {
    echo "=========================================================================================="
    echo >&2 "Please install Docker Compose - instructions in README.md"
    echo "=========================================================================================="
    exit 1
}

command -v jq >/dev/null 2>&1 || {
    echo "=========================================================================================="
    echo >&2 "Please install jq - instructions in README.md"
    echo "=========================================================================================="
    exit 1
}

command -v java >/dev/null 2>&1 || {
    echo "=========================================================================================="
    echo >&2 "Please install java - instructions in README.md"
    echo "=========================================================================================="
    exit 1
}

source ./bin/set-environment-variables.sh

./ccd compose down

./ccd compose up -d

echo "Everything looks ok. It may take 5 - 10 minutes for all containers to start"

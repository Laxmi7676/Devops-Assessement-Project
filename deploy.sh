#!/bin/bash

set -e

echo "Updating packages..."

sudo apt update

echo "Starting containers..."

docker compose down

docker compose up -d --build

echo "Deployment Complete"

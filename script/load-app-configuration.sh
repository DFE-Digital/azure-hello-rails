#!/bin/bash

date

if [ ! -f "~/app-configuration.env" ]; then
  token=$(./script/azure-tools/authentication/managed-identity/get-access-token.sh $APP_CONFIG_ENDPOINT)
  keyValues=$(./script/azure-tools/app-configuration/list-key-values.sh $APP_CONFIG_ENDPOINT $token)
  exportableEnvVars=$(echo $keyValues | jq -r 'map("export \(.key)=\"\(.value)\"") | join(";\n")')

  echo $exportableEnvVars > ~/app-configuration.env
fi

source ~/app-configuration.env

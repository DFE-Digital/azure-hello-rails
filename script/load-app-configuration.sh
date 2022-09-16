#!/bin/bash

# Persist the environment variables into a file for later access
# When SSH'ing into the container the Azure provided ENV vars are missing

if [ ! -f "/myapp/app-configuration.env" ]; then
  # Save any container injected ENV vars first

  env | while IFS= read -r line; do
    IFS='=' read -r key value <<< "$line"
    echo -en "export $key=\"$value\"\n" >> /myapp/app-configuration.env
  done

  # Gather and save variables from Application configuration

  # Get an access token to call the Application Configuration REST API

  if [ -z "$IDENTITY_ENDPOINT" ]; then
    # Container instances dont have IDENTITY_ENDPOINT set, App services do.
    token=$(./script/azure-tools/authentication/managed-identity/azure-container-instance/get-access-token.sh $APP_CONFIG_ENDPOINT)
  else
    token=$(./script/azure-tools/authentication/managed-identity/azure-app-service/get-access-token.sh $APP_CONFIG_ENDPOINT)
  fi

  # Call Application Configuration REST API with token and format the output in `export ENV="Var"` statements

  ./script/azure-tools/app-configuration/list-key-values.sh $APP_CONFIG_ENDPOINT $token | jq -r 'map("export \(.key)=\"\(.value)\"") | join("\n")' >> /myapp/app-configuration.env

  # Sort for ease of inspection later

  sort -o /myapp/app-configuration.env /myapp/app-configuration.env
fi

source /myapp/app-configuration.env

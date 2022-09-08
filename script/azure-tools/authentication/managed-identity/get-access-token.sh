#!/bin/sh

# See documentation https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-use-vm-token#get-a-token-using-curl

# Call:
# ./get-access-token.sh RESOURCE
# => eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjJaUXBKM... (shortened)

# Output: an access token for use with the REST API of the given resource

# Params:
# $1 RESOURCE - The URI of the resource you wish to get an access token for

encodedResource=$(echo $1 | jq -Rr @uri)

rawResponse=$(curl -s "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$encodedResource" -H Metadata:true)

echo $rawResponse | jq -r .access_token

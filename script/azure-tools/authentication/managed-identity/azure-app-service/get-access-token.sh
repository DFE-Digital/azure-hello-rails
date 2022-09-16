#!/bin/sh

# Call:
# ./get-access-token.sh RESOURCE
# => eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjJaUXBKM... (shortened)

# Output: an access token for use with the REST API of the given resource

# Params:
# $1 RESOURCE - The URI of the resource you wish to get an access token for

encodedResource=$(echo $1 | jq -Rr @uri)

rawResponse=$(curl -s "$IDENTITY_ENDPOINT?api-version=2019-08-01&resource=$encodedResource" -H Metadata:true -H "X-Identity-Header:$IDENTITY_HEADER")

echo $rawResponse | jq -r .access_token

#!/bin/sh

# See documentation https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/azure-app-configuration/rest-api-key-value.md#list-key-values

# Call:
# ./list-key-values.sh ENDPOINT ACCESS_TOKEN
# =>
# [
#   {
#     "etag": "CJrOSJmE6blp3...",
#     "key": "MyAppConfigKey1",
#     "label": null,
#     "content_type": "",
#     "value": "MyAppConfigValue1",
#     "tags": {},
#     "locked": false,
#     "last_modified": "2022-08-30T15:28:48+00:00"
#   },
#   {
#     "etag": "CJrOSJmE6blp3...",
#     "key": "MyAppConfigKey2",
#     ... shortened
#   },
# ]

# Output: An array of each key-value pair object within the app config store, intended for use with jq

# Params:
# $1 ENDPOINT - The app configuration endpoint (no trailing forward slash)
# $2 ACCESS_TOKEN - An access token used to make requests to the resource

endpoint=$1
token=$2

appConfigurationResponse=$(curl -s $endpoint/kv?api-version=1.0 -H "Authorization: Bearer $token")

echo $appConfigurationResponse | jq -r '.items'

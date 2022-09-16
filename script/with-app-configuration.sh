#!/bin/bash

. ./script/load-app-configuration.sh

export PATH=$PATH:/usr/local/bundle/bin
export BUNDLE_APP_CONFIG=/usr/local/bundle
export GEM_HOME=/usr/local/bundle

exec "$@"

#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/opsman-env.sh

cf_api_endpoint=$(terraform output cf_api_endpoint)
cf_admin_password=$(om credentials -p cf -c .uaa.admin_credentials -t json | jq -r '.password')

echo "Authenticating to CF with username 'admin' and password '$cf_admin_password'"
echo ""

cf login -a $cf_api_endpoint -u admin -p $cf_admin_password -o system -s system
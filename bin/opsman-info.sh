#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $DIR/opsman-env.sh

echo "OpsManager information"
echo ""
echo "Endpoint: https://${OM_TARGET}"
echo "Username: ${OM_USERNAME}"
echo "Password: ${OM_PASSWORD}"

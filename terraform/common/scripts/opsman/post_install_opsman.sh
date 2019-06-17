#!/bin/bash

set -e

source ~/.om_profile

bosh_director_ip=$1

bosh_env=default

# Setup BOSH CLI
bosh alias-env $bosh_env -e $bosh_director_ip --ca-cert /var/tempest/workspaces/default/root_ca_certificate

uaa_login_creds=$(om curl --path /api/v0/deployed/director/credentials/uaa_login_client_credentials -s | jq -r '.credential.value.password')
uaa_admin_creds=$(om curl --path /api/v0/deployed/director/credentials/uaa_admin_user_credentials -s | jq -r '.credential.value.password')

bosh_password=$(date +%s | sha256sum | base64 | head -c 16 ; echo)

uaac target $bosh_director_ip:8443 --skip-ssl-validation

uaac token owner get login admin -s $uaa_login_creds -p $uaa_admin_creds

uaac client delete bosh-login || true
uaac client add bosh-login --scope uaa.none --authorized_grant_types client_credentials --authorities bosh.admin -s $bosh_password

cat << EOF > ~/.bosh_profile
export BOSH_CLIENT=bosh-login
export BOSH_CLIENT_SECRET=$bosh_password
export BOSH_ENVIRONMENT=$bosh_env
EOF

source ~/.bosh_profile

# Test authentication
bosh vms
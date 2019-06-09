#!/bin/bash

set -e

PRODUCT_NAME=$1

source ~/.om_profile

if [ -z "$PRODUCT_NAME" ]; then
  echo "Error setting up tile - product name not specified"
  exit 1
fi

config_path="/home/ubuntu/config/$PRODUCT_NAME-config.yml"
ops_path="/home/ubuntu/config/$PRODUCT_NAME-config-ops.yml"

if [ -f "$ops_path" ]; then
  om configure-product -c "$config_path" -o "$ops_path"
else
  om configure-product -c "$config_path"
fi
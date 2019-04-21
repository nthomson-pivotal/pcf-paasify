#!/bin/bash

set -e

PRODUCT_NAME=$1
AZ_CONFIG_NAME=$2

source ~/.om_profile

if [ -z "$PRODUCT_NAME" ]; then
  echo "Error setting up tile - product name not specified"
  exit 1
fi

config_path="/home/ubuntu/config/$PRODUCT_NAME-config.json"
resource_path="/home/ubuntu/config/$PRODUCT_NAME-resources.json"
az_path="/home/ubuntu/config/az-$AZ_CONFIG_NAME-config.json"

if [ ! -f "$config_path" ]; then
  PRODUCT_CONFIG="{}"
else
  PRODUCT_CONFIG="$(cat $config_path)"
fi

if [ ! -f "$resource_path" ]; then
  RESOURCE_CONFIG="{}"
else
  RESOURCE_CONFIG="$(cat $resource_path)"
fi

if [ ! -f "$az_path" ]; then
  echo "Error: $az_path does not exist, check AZ config name ($AZ_CONFIG_NAME)"
  exit 1
fi

AZ_CONFIG="$(cat $az_path)"

# Temporary until proper fix for race condition
sleep 30

om configure-product --product-name "$PRODUCT_NAME" -pn "$AZ_CONFIG"

sleep 5

om configure-product --product-name "$PRODUCT_NAME" -p "$PRODUCT_CONFIG" -pr "$RESOURCE_CONFIG"
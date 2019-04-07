#!/bin/bash

set -e

if [ -z "$PRODUCT_NAME" ]; then
  echo "Error setting up tile - product name not specified"
  exit 1
fi

if [ -z "$PRODUCT_CONFIG" ]; then
  PRODUCT_CONFIG="{}"
fi

if [ -z "$AZ_CONFIG" ]; then
  AZ_CONFIG="{}"
fi

if [ -z "$RESOURCE_CONFIG" ]; then
  RESOURCE_CONFIG="{}"
fi

# Temporary until proper fix for race condition
sleep 30

om -t https://$OM_DOMAIN configure-product --product-name "$PRODUCT_NAME" -pn "$AZ_CONFIG"

om -t https://$OM_DOMAIN configure-product --product-name "$PRODUCT_NAME" -p "$PRODUCT_CONFIG" -pr "$RESOURCE_CONFIG"
#!/bin/bash

set -e

echo 'Configuring PAS...'
om -t https://$OM_DOMAIN configure-product --product-name cf -p "$PAS_CONFIG" -pn "$PAS_AZ_CONFIG" -pr "$PAS_RES_CONFIG"

# Iaas-specific configuration
om -t https://$OM_DOMAIN configure-product --product-name cf -p "$PAS_CUSTOM_CONFIG"

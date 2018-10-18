#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name p-redis -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG" -pr "$RESOURCE_CONFIG"

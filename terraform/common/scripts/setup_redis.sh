#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-redis -v 1.13.4

#om -t https://$OM_DOMAIN configure-product --product-name p-redis -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG" -pr "$REDIS_RES_CONFIG"

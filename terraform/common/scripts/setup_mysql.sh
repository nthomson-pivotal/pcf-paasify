#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p pivotal-mysql -v 2.2.4-build.17

om -t https://$OM_DOMAIN configure-product --product-name pivotal-mysql -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG"

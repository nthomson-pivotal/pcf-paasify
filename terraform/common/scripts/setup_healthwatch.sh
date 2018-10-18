#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name p-healthwatch -p "$HEALTHWATCH_PRODUCT_CONFIG" -pn "$HEALTHWATCH_AZ_CONFIG" -pr "$HEALTHWATCH_RES_CONFIG"

#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-healthwatch -v 1.1.8-build.1

echo 'Configuring Healthwatch...'
om -t https://$OM_DOMAIN configure-product --product-name p-healthwatch -p "$HEALTHWATCH_PRODUCT_CONFIG" -pn "$HEALTHWATCH_AZ_CONFIG" -pr "$HEALTHWATCH_RES_CONFIG"

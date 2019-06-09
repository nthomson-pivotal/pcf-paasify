#!/bin/bash

set -e

om -t https://$OM_DOMAIN configure-product --product-name wavefront-nozzle -p "$WAVEFRONT_PRODUCT_CONFIG" -pn "$WAVEFRONT_AZ_CONFIG"

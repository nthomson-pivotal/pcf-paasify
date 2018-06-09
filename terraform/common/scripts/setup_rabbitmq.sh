#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-rabbitmq -v 1.11.12

om -t https://$OM_DOMAIN configure-product --product-name p-rabbitmq -p "$PRODUCT_CONFIG" -pn "$AZ_CONFIG" -pr "$RABBITMQ_RES_CONFIG"

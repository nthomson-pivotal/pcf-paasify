#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p cf -v 2.1.0

echo 'Configuring PAS...'
om -t https://$OM_DOMAIN configure-product --product-name cf -p "$PAS_CONFIG" -pn "$PAS_AZ_CONFIG" -pr "$PAS_RES_CONFIG"

# Disable autoscaling smoke test for the moment as its breaking
om -t https://$OM_DOMAIN set-errand-state -p cf -e test-autoscaling --post-deploy-state disabled

# Disable NFS broker deploy since its not used right now
om -t https://$OM_DOMAIN set-errand-state -p cf -e nfsbrokerpush --post-deploy-state disabled

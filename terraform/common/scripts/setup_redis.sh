#!/bin/bash

set -e

om -k -t https://$OM_DOMAIN stage-product -p p-redis -v 1.12.6
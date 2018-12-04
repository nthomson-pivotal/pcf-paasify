#!/bin/bash

om -k -t https://$OM_DOMAIN -u $OM_USERNAME -p $OM_PASSWORD delete-installation

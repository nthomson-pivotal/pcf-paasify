#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

tmp_ssh_file="$(mktemp)"

terraform output opsman_ssh_private_key > $tmp_ssh_file

chmod 400 $tmp_ssh_file

ssh -i $tmp_ssh_file ubuntu@$(terraform output opsman_host)
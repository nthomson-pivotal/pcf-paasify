#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cloud=$1

if [ -z "$cloud" ]; then
  echo "Error: Missing cloud name"
  exit 1
fi


branch=$(git rev-parse --abbrev-ref HEAD)

env_name="ci-${branch//./-}"
stack_name="paasify-${env_name}-${cloud}"

echo "Updating stack $stack_name for environment $env_name on $cloud"

# aws cli doens't seem to like when this is formatted on to multiple lines, bleh
aws cloudformation create-stack --stack-name $stack_name --capabilities CAPABILITY_NAMED_IAM --template-body file://$DIR/../codebuild/cloudformation/cf.json --parameters ParameterKey=EnvName,ParameterValue=$env_name ParameterKey=DnsSuffix,ParameterValue=$cloud.paasify.org ParameterKey=Cloud,ParameterValue=$cloud ParameterKey=SourceBranch,ParameterValue=$branch
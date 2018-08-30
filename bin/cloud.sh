# Include to validate cloud specified

if [ -z "$cloud" ]; then
  echo "Error: Cloud provider must be specified"
  exit 1
fi

export CLOUD_TF_DIR=$CODEBUILD_SRC_DIR/terraform/$cloud

if [ ! -d "$CLOUD_TF_DIR" ]; then
  echo "Cloud $cloud does not appear to be supported (Terraform directory not found"
  exit 1
fi

if [ "$cloud" = "gcp" ]; then
    echo "Bootstrapping Google Cloud..."

    #export GCLOUD_ACCOUNT=$(aws ssm get-parameter --name /paasify/gcp/account_name  | jq '.Parameter.Value' -r)
    export GCLOUD_PROJECT=$(aws ssm get-parameter --name /paasify/gcp/project_name  | jq '.Parameter.Value' -r)

    #export GCLOUD_KEYFILE_JSON=$(aws ssm get-parameter --name /paasify/gcp/auth.json --with-decryption  | jq '.Parameter.Value' -r)

    export TF_VAR_project=$GCLOUD_PROJECT_NAME
fi
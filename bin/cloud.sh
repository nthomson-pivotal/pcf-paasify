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

    export GCLOUD_ACCOUNT_NAME=$(aws ssm get-parameter --name /paasify/gcp/account_name  | jq '.Parameter.Value' -r)
    export GCLOUD_PROJECT_NAME=$(aws ssm get-parameter --name /paasify/gcp/project_name  | jq '.Parameter.Value' -r)

    aws ssm get-parameter --name /paasify/gcp/auth.json --with-decryption  | jq '.Parameter.Value' -r > /tmp/auth.json

    gcloud auth activate-service-account $GCLOUD_ACCOUNT_NAME \
            --key-file=/tmp/auth.json --project=$GCLOUD_PROJECT_NAME


    gcloud compute instances list

    exit 1
fi
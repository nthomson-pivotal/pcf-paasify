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

if [ "$cloud" == "gcp" ]; then

fi
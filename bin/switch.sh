#!/bin/bash

# Switch to the correct Git branch/tag before we run anything else
# Need this to make up for CodeBuild limitations

set -e

if [ ! -d "$CODEBUILD_SRC_DIR/.git" ]; then
  echo "No .git, skipping branch switch"
  exit
fi

if [ ! -z "$branch" ]; then
  echo "Checking out Git branch $branch"

  git checkout $branch
elif [ ! -z "$tag" ]; then
  echo "Checking out Git tag $tag"

  git checkout tags/$TAG
else
  echo "No Git branch/tag specified, taking no action"
fi
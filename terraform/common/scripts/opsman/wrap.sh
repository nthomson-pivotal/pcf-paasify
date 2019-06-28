#!/bin/bash

echo "Wrapping $1"

{
  eval "$@"
} || {
    echo "Caught error in $1"
    # This is needed to ensure output
    sleep 1
    exit 1
}

echo "Finished $1"
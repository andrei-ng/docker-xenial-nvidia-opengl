#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./build.sh GIVEN_IMAGE_NAME"
  return 1
fi

# Build the docker image
docker build -t $1 .
#!/usr/bin/env bash

# Check args
if [ "$#" -ne 1 ]; then
  echo "usage: ./run.sh GIVEN_IMAGE_NAME"
  return 1
fi

set -e

# Get your current host nvidia driver version, e.g. 340.24
nvidia_version=nvidia-$(cat /proc/driver/nvidia/version | head -n 1 | awk '{ print $8 }' | awk -F'[_.]' '{print $1}')
NVIDIA_DRIVER="/usr/lib/$nvidia_version"

# Run the container NVIDIA Graphics acceleration shared X11
nvidia-docker run --rm \
  --net=host \
  --ipc=host \
  --privileged \
  -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
  -v $HOME/.Xauthority:/root/.Xauthority -e XAUTHORITY=/root/.Xauthority \
  -v ${NVIDIA_DRIVER}:/usr/local/nvidia/lib \
  -v ${NVIDIA_DRIVER}:/usr/local/nvidia/lib64 \
  -e DISPLAY=$DISPLAY \
  -it $1
#!/bin/bash

CONTAINER="alpha1s_kinect_cont"
IMAGE="ros"
IMAGE_VERSION="latest"
IMAGE_FULL="$IMAGE:$IMAGE_VERSION"
VOLUME_SRC="$(pwd)/shared_volume"
VOLUME_DST="/root"

# Allow container to access X server
xhost +local:root 

# Remove conflicting Kinect kernel module if present
if lsmod | grep "gspca_kinect" &> /dev/null ; then
    echo "Removing conflicting Kinect kernel module, please enter pasword:"
    sudo rmmod gspca_kinect
fi

# Start new container shell if running
if [ "$(docker container list | grep "$CONTAINER")" ]; then
    docker exec -it "$CONTAINER" bash
    exit 0
fi

# Start container if it exists but not running
if [ "$(docker container list -a | grep "$CONTAINER")" ]; then
    docker start "$CONTAINER" && docker attach "$CONTAINER"
    exit 0
fi

# Download image if missing
if [ ! "$(docker image ls | grep "$IMAGE")" ]; then
    docker pull "$IMAGE_FULL"
fi

# Create container if it doesn't exist
docker run \
    --name $CONTAINER \
    -e DISPLAY=$DISPLAY \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --workdir=$VOLUME_DST \
    --volume $VOLUME_SRC:$VOLUME_DST \
    --volume /dev/bus/usb:/dev/bus/usb --privileged \
    -it $IMAGE_FULL

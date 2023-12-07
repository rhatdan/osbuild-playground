#!/bin/sh -xe
if [ -z "$1" ]; then
        echo must specify an image name
	exit
fi
IMAGE=$1
podman login quay.io
cp $HOME/.ssh/id_rsa.pub root.keys
podman build -t $IMAGE .
podman push $IMAGE
mkdir -p output
sudo podman run --rm -it --security-opt label=type:unconfined_t --privileged -v $XDG_RUNTIME_DIR/containers/auth.json:/run/containers/0/auth.json -v ./output:/output --pull newer quay.io/centos-bootc/bootc-image-builder $IMAGE
sudo chown -R $UID output

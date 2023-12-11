#!/bin/sh -xe
if [ -z "$1" ]; then
        echo must specify an image name
	exit
fi
IMAGE=$1
case "$OSTYPE" in
    darwin*)
	podman machine stop || true;
	podman machine set --rootful;
	podman machine start;;
esac

podman login quay.io
cp $HOME/.ssh/id_rsa.pub root.keys
podman build -t $IMAGE .
podman push $IMAGE
mkdir -p /tmp/output
sudo podman run --rm -it --security-opt label=type:unconfined_t --privileged -v /tmp/output:/output --pull newer quay.io/centos-bootc/bootc-image-builder $IMAGE
sudo chown -R $UID output

case "$OSTYPE" in
    podman machine ssh cp /tmp/output/qcow2/disk.qcow2 /Users/danwalsh/ $(basename $IMAGE).qcow2
esac

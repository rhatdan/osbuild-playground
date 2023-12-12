#!/bin/sh -xe
if [ -z "$1" ]; then
        echo must specify an image name
	exit
fi
IMAGE=$1
AI_IMAGE=$2
rootless=$(podman info --format '{{ .Host.Security.Rootless }}')
echo $rootless
if [[ "$rootless" = "true" ]]; then
    case "$OSTYPE" in
	darwin*)
	    podman machine stop || true;
	    podman machine set --rootful;
	    podman machine start;
	    podman machine mkdir -p /tmp/output;;
    esac
fi
cp $HOME/.ssh/id_rsa.pub root.keys
sudo podman login quay.io
sudo podman build --env AI_IMAGE=$AI_IMAGE --cap-add SYS_ADMIN -t $IMAGE .
sudo podman push $IMAGE
sudo mkdir -p /tmp/output
sudo podman run --rm -it --security-opt label=type:unconfined_t --privileged -v /tmp/output:/output --pull newer quay.io/centos-bootc/bootc-image-builder $IMAGE

case "$OSTYPE" in
	darwin*)
	    podman machine ssh cp /tmp/output/qcow2/disk.qcow2 /Users/danwalsh/$(basename $IMAGE).qcow2;;
esac

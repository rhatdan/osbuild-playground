#!/bin/sh -xe
if [ -z "$1" ]; then
        echo must specify an image name
	exit
fi
IMAGE=$1
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
podman login quay.io
cp $HOME/.ssh/id_rsa.pub root.keys
podman build -t $IMAGE .
podman push $IMAGE
mkdir -p /tmp/output
podman run --rm -it --security-opt label=type:unconfined_t --privileged -v /tmp/output:/output --pull newer quay.io/centos-bootc/bootc-image-builder $IMAGE

case "$OSTYPE" in
	darwin*)
	    podman machine ssh cp /tmp/output/qcow2/disk.qcow2 /Users/danwalsh/$(basename $IMAGE).qcow2;;
esac

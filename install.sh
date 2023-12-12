#!/bin/sh -xe
if [ -z "$1" ]; then
        echo must specify an image name
	exit
fi
IMAGE=$1
AI_IMAGE=$2
SUDO=sudo
remote=$(podman info --format '{{.Host.ServiceIsRemote}}')
if [[ "$remote" = "true" ]]; then
    SUDO=""
fi

rootless=$(podman info --format '{{ .Host.Security.Rootless }}')
if [[ "$rootless" = "true" ]]; then
    case "$OSTYPE" in
	"darwin*" | "windows*")
	    podman machine stop || true;
	    podman machine set --rootful;
	    podman machine start;
	    podman machine mkdir -p /tmp/output;;
    esac
fi
cp $HOME/.ssh/id_rsa.pub root.keys
$SUDO podman login quay.io
$SUDO podman build --env AI_IMAGE=$AI_IMAGE --cap-add SYS_ADMIN -t $IMAGE .
$SUDO podman push $IMAGE
$SUDO mkdir -p /tmp/output
$SUDO podman run --rm -it --security-opt label=type:unconfined_t --privileged -v /tmp/output:/output --pull newer quay.io/centos-bootc/bootc-image-builder $IMAGE

case "$OSTYPE" in
	darwin*)
	    podman machine ssh cp /tmp/output/qcow2/disk.qcow2 /Users/danwalsh/$(basename $IMAGE).qcow2;;
esac

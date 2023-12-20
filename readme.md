# Overview
This repo will allow us to create bootable container based on a base image and target image that we will specify
while running the script

## How to run the script

`sh install.sh quay.io/rbrhssa/bchris registry.fedoraproject.org/fedora:latest`

The above command will take two arguments , of which the first one will be the target image and second one is the base image.

### What is the Containerfile doing ?

It sets up an image based on a Fedora image, configures SSH with a specified 
public key, installs an HTTP server, sets up storage configurations, 
pulls the base image i.e  using Podman, lists images with Podman , and performs an OSTree container commit.

### Example output of last few lines

`⏱  Duration: 35s
build:    	5cfeabcf7f832618b6b0d3448f2c93909c6b60afbb125e1d03a8a456c8cf5358
ostree-deployment:	f5d3bad01b75b0441aef26b414733a1678189537547203c601345af155e6a8dc
image:    	387a5804be5ce28edb7fb6643fed11c933f46a5955ca7e725e3276ba5c43ba6b
qcow2:    	1d9001b7124ed7c43fd0c6852895321a9242f11844c74a597daee37d926ac066
Build complete!
Results saved in
/output`
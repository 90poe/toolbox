#!/usr/bin/env bash

docker run \
  --interactive \
  --tty \
  --rm \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  --volume ~/.aws:/root/.aws:ro \
  --volume ~/.kube:/root/.kube:ro \
  --volume ~/.ssh:/root/.ssh:rw \
  --volume ~/.gitconfig:/root/.gitconfig:ro \
  --volume ~/.git-crypt:/root/.git-crypt \
  --volume ~/Work:/root/Work:rw \
  --name toolbox \
  toolbox

#!/usr/bin/env bash

docker run \
  --interactive \
  --tty \
  --rm \
  --volume ~/.aws:/root/.aws:ro \
  --volume ~/.kube:/root/.kube:ro \
  --volume ~/.ssh:/root/.ssh:ro \
  --volume ~/Work:/root/Work:rw \
  --name toolbox \
  toolbox

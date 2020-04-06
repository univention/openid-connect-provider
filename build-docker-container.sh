#!/bin/bash

set -xe

DOCKER_IMG_VERSION=${DOCKER_IMG_VERSION:-latest}

# make sure the latest image is used locally
docker pull $(cat Dockerfile | grep FROM | awk '{print $2}')

docker build \
	--force-rm \
	--no-cache \
	-t openid-connect-provider:$DOCKER_IMG_VERSION \
	./

docker tag openid-connect-provider:$DOCKER_IMG_VERSION docker-test-upload.software-univention.de/openid-connect-provider:$DOCKER_IMG_VERSION
docker push docker-test-upload.software-univention.de/openid-connect-provider:$DOCKER_IMG_VERSION

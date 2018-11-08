#!/bin/bash

set -xe

DOCKER_IMG_VERSION=${DOCKER_IMG_VERSION:-latest}

# build identifier app
srcimg="debian:stretch"

docker run \
	--rm \
	--volume "$(pwd)/login/":/src/login \
	--entrypoint /src/login/build-identifier-docker.sh  \
	"$srcimg" /src/login/identifier

# build oidc-provider docker image
if [ ! -e login/identifier/build ]; then
	echo "No build directory, build failed"
	exit 1
fi

docker build \
	--force-rm \
	--no-cache \
	-t oidc-provider:$DOCKER_IMG_VERSION \
	./

docker tag oidc-provider:$DOCKER_IMG_VERSION docker-test.software-univention.de/oidc-provider:$DOCKER_IMG_VERSION
docker push docker-test.software-univention.de/oidc-provider:$DOCKER_IMG_VERSION

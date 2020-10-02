#!/bin/bash

set -xe

DOCKER_IMG_VERSION=0.33.8
DOCKER_IMG=kopano/kopano_konnect
UCS_IMG=openid-connect-provider
UCS_IMG_VERSION=2.0-konnect-0.33.8


docker build --force-rm --no-cache --pull -t "$UCS_IMG:$UCS_IMG_VERSION" -<<EOF
# hadolint ignore=DL3007
FROM $DOCKER_IMG:$DOCKER_IMG_VERSION

# COPY login/identifier/build /var/lib/konnectd-docker/identifier-univention
EOF

docker tag $UCS_IMG:$UCS_IMG_VERSION docker-test-upload.software-univention.de/$UCS_IMG:$UCS_IMG_VERSION
docker push docker-test-upload.software-univention.de/$UCS_IMG:$UCS_IMG_VERSION

docker tag $UCS_IMG:$UCS_IMG_VERSION docker-upload.software-univention.de/$UCS_IMG:$UCS_IMG_VERSION
docker push docker-upload.software-univention.de/$UCS_IMG:$UCS_IMG_VERSION

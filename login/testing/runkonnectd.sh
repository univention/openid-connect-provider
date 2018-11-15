#!/bin/bash

set -x

# Make sure openid-connect-provider app is installed
## univention-install -y univention-appcenter-dev; univention-app dev-use-test-appcenter; univention-app update
## univention-app install openid-connect-provider
# ALSO make sure the app is stopped so we can test:
## service docker-app-openid-connect-provider stop

docker run --env-file /var/lib/univention-appcenter/apps/openid-connect-provider/openid-connect-provider.env \
	--rm \
	--volume /etc/kopano/konnectd-tokens-signing-key.pem:/run/secrets/konnectd_signing_private_key:ro \
	--volume /etc/kopano/konnectd-encryption.key:/run/secrets/konnectd_encryption_secret:ro \
	--volume /etc/kopano/konnectd.ldap_binddn:/run/secrets/konnectd.ldap_binddn:ro \
	--volume /etc/kopano/konnectd.machine.secret:/run/secrets/konnectd.machine.secret:ro \
	--volume /etc/kopano:/etc/kopano:ro \
	--volume /var/konnect-login:/var/lib/konnectd-docker/identifier-univention:rw \
	--publish 127.0.0.1:8777:8777 \
	kopano/konnectd:0.9.0 \
	--iss=https://master.ucs.local \
 	--identifier-client-path ./identifier-univention \
	serve ldap

# hadolint ignore=DL3007
FROM fbartels/kopano_konnect:latest

COPY login/identifier/build /var/lib/konnectd-docker/identifier-univention
COPY docker-entrypoint-univention.sh /usr/local/bin/docker-entrypoint-univention.sh

ENTRYPOINT ["docker-entrypoint-univention.sh"]

# hadolint ignore=DL3007
FROM kopano/kopano_konnect:latest

COPY login/identifier/build /var/lib/konnectd-docker/identifier-univention

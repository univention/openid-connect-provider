# TODO after done testing change to kopano/kopano_konnect:latest
# hadolint ignore=DL3007
FROM fbartels/kopano_konnect:latest

COPY login/identifier/build /var/lib/konnectd-docker/identifier-univention

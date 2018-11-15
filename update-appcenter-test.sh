#!/bin/bash

set -e
set -x

APP_VERSION="4.3/openid-connect-provider"

selfservice () {
	local uri="https://provider-portal.software-univention.de/appcenter-selfservice/univention-appcenter-control"
	local first=$1
	shift

	USERNAME="$USER"
	[ -e "$HOME/.univention-appcenter-user" ] && USERNAME="$(< $HOME/.univention-appcenter-user)"

	PWDFILE="~/.selfservicepwd"
	[ -e "$HOME/.univention-appcenter-pwd" ] && PWDFILE="$HOME/.univention-appcenter-pwd"

	curl -sSfL "$uri" | python - "$first" --username=${USERNAME} --pwdfile=${PWDFILE} "$@"
}

die () {
	echo "$@"
	exit 1
}

[ "$IGN_GIT" != "true" ] && test -n "$(git status -s)" && die "Changes in repo, do not upload app!"

# preinst
cp app/preinst.tmpl preinst
sed -i -e "/%OIDC_PROVIDER_CONFIG_TEMPLATE%/r app/files/identifier-registration.yaml" -e "/%OIDC_PROVIDER_CONFIG_TEMPLATE%/d" preinst

# joinscript
cp app/inst.tmpl inst
sed -i -e "/%OIDC_PROVIDER_LISTENER%/r app/files/openid-connect-provider.listener" -e "/%OIDC_PROVIDER_LISTENER%/d" inst
sed -i -e "/%OIDC_PROVIDER_APACHE_CONF%/r app/files/openid-connect-provider.conf" -e "/%OIDC_PROVIDER_APACHE_CONF%/d" inst
sed -i -e "/%OIDC_PROVIDER_SCHEMA%/r app/files/openid-connect-provider.schema" -e "/%OIDC_PROVIDER_SCHEMA%/d" inst
sed -i -e "/%OIDC_PROVIDER_UDM_MODULE%/r app/files/openid-connect-provider.udm-module" -e "/%OIDC_PROVIDER_UDM_MODULE%/d" inst
sed -i -e "/%OIDC_PROVIDER_ACL%/r app/files/openid-connect-provider.ldapacl" -e "/%OIDC_PROVIDER_ACL%/d" inst

# config
cp app/configure_host.tmpl configure_host


# upload
selfservice upload "$APP_VERSION" app/env app/uinst app/test preinst inst configure_host

rm -f inst
rm -f configure_host
rm -f preinst

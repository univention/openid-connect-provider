#!/bin/bash

set -e
set -x

# Put app provider portal username into $HOME/.univention-appcenter-user and the password into $HOME/.univention-appcenter-pwd

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

[ "$IGN_GIT" != "true" ] && test -n "$(git status -s)" && die "Changes in repo, do not upload app! (to override: IGN_GIT=true)"

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


# upload
selfservice upload "$APP_VERSION" app/env app/uinst app/test app/settings app/configure app/configure_host preinst inst README_*

rm -f inst
rm -f configure_host
rm -f preinst

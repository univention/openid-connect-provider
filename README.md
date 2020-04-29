# OpenID Connect Provider app

[UCS manual about the app](https://docs.software-univention.de/manual-4.4.html#domain:oidc)
Latest documentation. See here how to setup the app correctly. Blog entries may contain outdated information and should only be used as a reference to figure out how to setup relying party service against this app

[Blog article about app release - Info about Wordpress setup](https://www.univention.de/blog-de/2018/12/openid-connect-provider/)
[Internal article about Setting up Nextcloud](ihttps://nissedal.knut.univention.de/~edamrose/oidc_nextcloud_anbindung.html)

[OpenID Connect Provider app in the UCS App catalogue](https://www.univention.de/produkte/univention-app-center/app-katalog/openid-connect-provider/)


# App base

The app uses [Kopano konnect](https://github.com/Kopano-dev/konnect) to provide an OpenID Connect provider.

The docker image used in the app is [kopano_konnect](https://github.com/zokradonh/kopano-docker.git), provided by kopano as well. It contains an adapted wrapper.sh to help integrate the app settings. Since app version 2.0++ no separate Dockerimage is built by Univention.


# SAML Support

With App version 2.0++ SAML is used as the authentication backend. Users are authenticated via SAML, but to query the user information to fill in the oidc claims konnect uses its LDAP backend.

When an OIDC relying party is setup against the OIDC App, the user flow should be:
```
RP				OIDC App 			SAML		LDAP
login page ->
				no session? ->
									login
				authenticated 	<-
login at RP
get userinfo ->
				fetch ---------------------->  ldapsearch
```

# Tests

An app specific test exists in [app/test](app/test)

TODO: describe manual tests
- setup relying party, test login with ucs user
- test logout with ucs user, logged into several SAML apps
- test redirect to signout-url when logging out of OIDC App
- Test OIDC App on DC Master and backup (gets installed on ucs-sso.$domain vhost) and other roles (gets installed on $hostname.$domain vhost)
- ...

# Internals

See [app/](app/) for app center integration files

## App updates

The script update-appcenter-test.sh can be used to build and upload the files from the repo for the latest test app center app version

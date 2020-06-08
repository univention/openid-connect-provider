# OpenID Connect Provider app

[UCS manual about the app](https://docs.software-univention.de/manual-4.4.html#domain:oidc)
Latest documentation. See here how to setup the app correctly. Blog entries may contain outdated information and should only be used as a reference to figure out how to setup relying party service against this app

[Blog article about app release - Info about Wordpress setup](https://www.univention.de/blog-de/2018/12/openid-connect-provider/)
[Internal article about Setting up Nextcloud](https://nissedal.knut.univention.de/~edamrose/oidc_nextcloud_anbindung.html)

[OpenID Connect Provider app in the UCS App catalogue](https://www.univention.de/produkte/univention-app-center/app-katalog/openid-connect-provider/)


# App base

The app uses [Kopano konnect](https://github.com/Kopano-dev/konnect) to provide an OpenID Connect provider.

The docker image used in the app is [kopano_konnect](https://github.com/zokradonh/kopano-docker.git), provided by kopano as well. It contains an adapted wrapper.sh to help integrate the app settings. Since app version 2.0++ no separate Dockerimage is built by Univention.


# SAML Support

With App version 2.0++ SAML is used as the authentication backend. Users are authenticated via SAML, but to query the user information to fill in the oidc claims, konnect uses its LDAP backend.

When an OIDC relying party is setup against the OIDC App, the user flow should be:
```
RP              OIDC App            SAML       LDAP
login page ->
                no session?     ->
                                    login
                authenticated   <-
login at RP
get userinfo ->
                fetch ---------------------->  ldapsearch
```

# Configuration

The app is configured with app settings.

Listener and configure scripts write to `/etc/kopano/konnectd-identifier-registration.yaml` and `/etc/kopano/konnectd.cfg`

New service can be registered with the udm module oidc/rpservice.

Only services below `cn=oidc,cn=univention,$ldap_base` are recognized.

To integrate other services, they often require URIs for the identity provider endpoints, they are available at `https://ucs-sso.$domainname/.well-known/openid-configuration`

By default the App registers the oidc SAML service for the Group "Domain Users", every member may use OIDC apps. An app setting deactivates this.

The apache2 config is at `/etc/apache2/conf-available/openid-connect-provider.conf`, linked to appropriate conf-dirs depending on the server role.

# Tests

All tests with browsers should happen in a new private browser window. This ensures that no cookies or old sessions are present.

All tests have to happen using actual hostnames with correct and verfifyable certificates. The involved services rely on and test for signed and trusted certificates.

An app specific test exists in [app/test](app/test)

Manual product tests
- Setup relying party, test login with ucs user
Install openid-connect-provider app. For an OIDC test app I use the owncloud app from the appcenter, version 10.4.1+ has an app setting to activate Login via OIDC. Ownclouds OIDC settings can be configured in the owncloud app settings.
UCS Users require a mailPrimaryAddress for this to work. Create a UCS user, login to the portal, use owncloud oidc login. No additional password should be required. In a new browser session, start with login to OIDC service. A login should be required at the SAML IdP.

- Test SAML logout with ucs user, logged into several SAML + OIDC apps
Log into UCS Portal, create session in other service, e.g. log into UMC. Log into OIDC service. Logout at portal. All SAML sessions and the OIDC session at konnect should be invalidated. That means, login is required for accessing further SAML and OIDC Apps. As OIDC has no concept of federated logout, existing sessions in other OIDC Apps are not terminated.

- Test redirect to signout-url when logging out of OIDC App
Log into OIDC App. Click logout button in OIDC App. All SAML and OIDC Sessions should be invalidated. The browser should be redirected to the logout URL configured in the OIDC App setting logout URL, when the app provides no redirect_uri to konnect. That is the case for e.g. owncloud. When logging out of Kopano Meet, the redirect will be to Kopano Meet itself.

- Test OIDC App on DC Master and backup (gets installed on ucs-sso.$domain vhost) and other roles (gets installed on $hostname.$domain vhost)
On installation, the app should configure the iss to ucs-sso.$domain on DC Master+Backup, and $hostname.$domain on other roles, check in app settings, and by checking openid-configuration at `.../.well-known/openid-configuration`
When changing the ISS parameter in app settings, the SAML sp (`ldapsearch SAMLServiceProviderIdentifier=openid-connect-provider`) should be updated to reflect the new URL. On slave and memberserver, the oidc app joinscript should be marked as pending, and after re-running it, the SAML sp object should be updated. There is no automatic apache reconfiguration, make sure a new vhost is configured in apache2.
OIDC logins should be possible, service may have to be reconfigured for the new URIs.

# Internals

See [app/](app/) for app center integration files

## App updates

The script update-appcenter-test.sh can be used to build and upload the files from the repo for the latest test app center app version

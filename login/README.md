# DEPENDENCIES
Dependencies for openid-connect-provider/identifier make

Necessary for installation (tested on UCS 4.3-1)

```
service ntp stop; ntpdate time.google.com; service ntp start
ucr set update/secure_apt='no'
ucr set repository/online/unmaintained='yes'
```

### make (v=?)
```
apt -y install build-essential
```

### yarn (v=?)
```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update
apt -y install yarn
```

### node (v>=6)
```
# the way nodejs 6.x is installed here is a bit hacky
touch /etc/apt/sources.list.d/nodesource.list
echo -e "deb https://deb.nodesource.com/node_6.x xenial main" >> /etc/apt/sources.list.d/nodesource.list;
echo -e "deb-src https://deb.nodesource.com/node_6.x xenial main" >> /etc/apt/sources.list.d/nodesource.list;
apt update
apt -y install nodejs
```

### ~~imagemagick (v=?)~~ not needed anymore
```
apt -y install imagemagick
```

### scour (v=?)
```
# (https://github.com/scour-project/scour)
apt -y install python-scour
```

### ~~inkscape (v=?)~~ not needed anymore
```
apt -y install inkscape
```



# TESTING
## setup
```
## VM
# install DEPENDENCIES
# install openid-connect-provider app (read comment in ~/git/openid-connect-provider/testing/runkonnectd.sh)
```

## testing loop
```
## local
rsync -r ./identifier 10.200.xx.xx:/root/

## vm
cd /root/identifier; make; rm -rf /var/konnect-login/*; cp -r ~/identifier/build/* /var/konnect-login/
```

## after first iteration of 'testing loop'
```
## local
scp ./testing/runkonnectd.sh 10.200.xx.xx:/root/

## vm
service docker-app-openid-connect-provider stop # (read comment in ~/git/openid-connect-provider/testing/runkonnectd.sh)
cd /root; bash runkonnectd.sh
```


# TODOs
- in identifier/src/Makefile kann viel entfernt werden, jetzt wo die Hintergrundbilder nicht mehr benutzt werden

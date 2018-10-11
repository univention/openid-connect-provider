#!/bin/bash

# $1 = directory with source files

set -xe

if [ -z "$1" ]; then
	echo "Source directory parameter missing"
	exit 1
fi

# setup dependencies
apt-get update
apt-get install -y curl gnupg

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb http://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list

# node
curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
echo deb http://deb.nodesource.com/node_8.x stretch main >> /etc/apt/sources.list

# install build dependencies
cat /etc/apt/sources.list
apt-get update
apt-get install -y build-essential yarn nodejs python-scour

cd "$1"
make

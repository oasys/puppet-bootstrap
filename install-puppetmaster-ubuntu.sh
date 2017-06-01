#!/usr/bin/env bash

set -e

# sanity checks
if [ "$(id -u)" != "0" ]; then
  echo "Please run script as root." >&2
  exit 1
fi
if [ ! -r /etc/lsb-release ]; then
  echo "Cannot determine distribution codename." >&2
  exit 1
else
  . /etc/lsb-release
fi
if [ $(grep MemTotal /proc/meminfo | awk '{print $2}') -lt 4000000 ]; then
  echo "Please configure server with minimum 4GB RAM." >&2
  exit 1
fi

# make sure everything is current
echo "Running apt-get upgrade..."
apt-get update >/dev/null && apt-get -y upgrade >/dev/null

# add repo and install puppet master
echo "Adding puppetlabs repo..."
tmpdir=$(mktemp)
wget -O "$tmpdir" "http://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRIB_CODENAME}" 2>/dev/null
dpkg -i "$tmpdir" >/dev/null
apt-get update >/dev/null

echo "Install puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null

echo "Finished."

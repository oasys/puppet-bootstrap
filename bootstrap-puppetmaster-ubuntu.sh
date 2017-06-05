#!/usr/bin/env bash
#
# set up an inital config with r10k/hiera/etc
# with inspiration from https://github.com/puppetinabox/controlrepo

set -e

MODPATH=/root/bootstrap/modules

mkdir -p $MODPATH
puppet module install --modulepath=$MODPATH jlambert121/puppet --version 0.8.2
puppet module install --modulepath=$MODPATH puppet/r10k --version 6.0.0
puppet module install --modulepath=$MODPATH hunner/hiera --version 2.0.2

puppet apply --modulepath=$MODPATH puppetserver.pp

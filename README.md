# puppet bootstrap

This is a simple set of scripts to bootstrap a puppet installation.

## What it does

- install PC1 puppet agent
- install PC1 puppetserver
- create and add deploy key to remote control repository
- install r10k
- configure webhook on puppet master and on control repo

## Compatability

### OS

Currently, only targeted and tested with Ubuntu 16.04.  I plan to add Debian jessie and stretch at some point, too.

- ubuntu 16.04

### Puppet

- puppet 4
- hiera 5

### Git

- git
- gitlab

## Install/use

- clone repo
- `cd puppet-bootstrap`
- `./install-agent-<os>.sh`
- `./bootstrap-puppetmaster-<os>.sh git@github.com/orgname/puppet-control [apitoken]`

## Problems

All patches/feedback welcome.

#!/usr/bin/env bash
#
# set up an inital config with r10k/hiera/etc
# with inspiration from https://github.com/puppetinabox/controlrepo

set -e
MODPATH=/root/bootstrap/modules
KEYFILE=/root/.ssh/r10k_rsa
mkdir -p $MODPATH

#validate input
REMOTE="$1"
TOKEN="$2"
echo $REMOTE | grep -q '^git@' || (echo "Please supply repo on commandline. (example: $0 git@github.com/orgname/puppet-control [token])" >&2; exit 1)

echo "Installing puppetserver..."
puppet apply puppetserver.pp

# genkey
[[ $REMOTE =~ @([^/:]+)[/:] ]] && HOST="${BASH_REMATCH[1]}"
[[ $REMOTE =~ .*[/:](.+/[^.]+)(.git)? ]] && REPO="${BASH_REMATCH[1]}"
[[ $REMOTE =~ gitlab ]] && PROVIDER='gitlab' || PROVIDER=git
echo "Adding host keys for $HOST to known_hosts..."
ssh-keyscan $HOST >> /root/.ssh/known_hosts

# set up deploy key
echo "Generating r10k ssh key..."
if [ -r ${KEYFILE}.pub ] ; then
  echo "Key exists, checking..."
  ssh-keygen -l -f ${KEYFILE}.pub || (echo "Invalid pubkey ${KEYFILE}.pub." >&2; exit 1)
else
  ssh-keygen -q -N '' -t rsa -b 4096 -C r10k -f $KEYFILE
fi
echo "Adding key to /root/.ssh/config for $HOST..."
cat >> /root/.ssh/config <<EOM
Host $HOST
  HostName $HOST
  User git
  IdentityFile $KEYFILE
EOM

if [ -z "$TOKEN" ]; then
  echo "Please give the following pubkey RO access to the repo, then hit <enter>."
  cat ${KEYFILE}.pub
  read
else
  echo "Adding the deploy key to the repo..."
  puppet module install --modulepath=$MODPATH abrader/gms --version 1.0.3
  FACTER_host="$HOST" \
  FACTER_repo="$REPO" \
  FACTER_token="$TOKEN" \
  FACTER_keyfile="${KEYFILE}.pub" \
  FACTER_provider="$PROVIDER" \
  puppet apply --modulepath=$MODPATH deploy_key.pp
fi

# deploy control repo
echo "Installing r10k..."
puppet module install --modulepath=$MODPATH puppet/r10k --version 6.0.0
FACTER_remote="$REMOTE" puppet apply --modulepath=$MODPATH r10k.pp

# add webhook
echo "Installing webhook..."
FACTER_host="$HOST" \
FACTER_repo="$REPO" \
FACTER_token="$TOKEN" \
FACTER_provider="$PROVIDER" \
puppet apply --modulepath=$MODPATH webhook.pp

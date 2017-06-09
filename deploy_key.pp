# add deploy key to remote repo

git_deploy_key { 'add_deploy_key_to_puppet_control':
  ensure       => present,
  name         => $::fqdn,
  path         => $::keyfile,
  token        => $::token,
  project_name => $::repo,
  server_url   => "http://${::host}",
  provider     => $::provider,
}

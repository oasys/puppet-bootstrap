# set up local webhook service and deploy integration on git server

class {'r10k::webhook':
  use_mcollective => false,
  user            => root,
  group           => 0,
}
->
class {'r10k::webhook::config':
  use_mcollective => false,
  enable_ssl      => false,
  protected       => true,
  notify          => Service['webhook'],
}

git_webhook { 'post_receive_webhook':
  ensure       => present,
  webhook_url  => "https://puppet:puppet@${::fqdn}:8088/payload",
  token        => $::token,
  project_name => $::repo,
  server_url   => "http://${::host}",
  provider     => $::provider,
}

Package { allow_virtual => true, }

class { '::puppet':
  server => true,
  server_version => latest,
  dns_alt_names => [
    'puppet',
  ],
  puppetdb_server => "puppet.${networking['domain']}",
  manage_puppetdb => false,
  manage_hiera => false,
  firewall => true,
  runmode => service,
}

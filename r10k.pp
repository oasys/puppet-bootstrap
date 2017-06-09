# install and deploy r10k

class { 'r10k':
  remote => $::remote,
}
->
exec { 'r10k deploy':
  command => '/usr/bin/r10k deploy environment -pv',
}

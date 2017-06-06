package { 'puppetserver': ensure => latest }
->
service { 'puppetserver': ensure => running }

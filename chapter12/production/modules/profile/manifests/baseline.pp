class profile::baseline {

  include ntp
  include profile::baseline::linux

#  file {'/var/log/custom':
#    ensure => directory,
#  }

  include profile::logging

  package{'http': ensure => present }

}

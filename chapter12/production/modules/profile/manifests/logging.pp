class profile::logging {

  file {'/var/log/custom':
    ensure => directory,
  }

}

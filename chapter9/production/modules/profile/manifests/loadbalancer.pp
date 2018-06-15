class profile::loadbalancer {
 # include haproxy

  class {'haproxy': enable => true }

  haproxy::listen {'myapp':
    ipaddress => $::ipaddress,
    ports => ['80','443']
  }

  Haproxy::Balancermember <<| listening_service == 'myapp' |>>
}

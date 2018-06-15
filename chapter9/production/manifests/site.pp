include profile::etchosts

include files::hammer
include files::scalpel

node 'haproxy' {
  include profile::loadbalancer
}

node 'wordpress' {
  include profile::balancermember
  class {'profile::appserver': db_pass => 'suP3rP@ssw0rd!' }
}

node 'mysql' {
  include profile::appserver::database
}

node default { }

# For the purposes of this demo, the next two lines can be used to ensure firewalls
# are off for all CentOS nodes.

# service {'iptables': ensure => stopped }
 service {'firewalld': ensure => stopped }

#site {
#  myapp { 'myapp':
#    dbpass => 'rarypass',
#    nodes => {
#      Node['mysql']       => [ Myapp::Db['myapp']],
#      Node['wordpress']   => [ Myapp::Web['myapp-1']],
#      Node['wordpress-2'] => [ Myapp::Web['myapp-2']],
#      Node['haproxy']     => [ Myapp::Lb['myapp-1']],
#      Node['haproxy-2']   => [ Myapp::Lb['myapp-2']],
#    }
#  }
#}

node default {
  include profile::baseline
}

#node default {}

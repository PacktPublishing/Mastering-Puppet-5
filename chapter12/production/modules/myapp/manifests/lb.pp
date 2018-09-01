define myapp::lb (
  $balancermembers,
  String $ipaddress     = '0.0.0.0',
  String $balance_mode  = 'roundrobin',
  String $port          = '80',
) {

  include haproxy

  haproxy::listen {"wordpress-${name}":
    collect_exported => false,
    ipaddress        => $::networking['interfaces']['enp0s8']['ip'],
    mode             => 'http',
    options          => {
      'balance' => $balance_mode,
    },
    ports            => $port,
  }

  $balancermembers.each |$member| {
    haproxy::balancermember { $member['host']:
      listening_service => "wordpress-${name}",
      server_names      => $member['host'],
      ipaddresses       => $member['ip'],
      ports             => $member['port'],
      options           => "check cookie ${member['host']}",
    }
  }

}

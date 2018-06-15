class profile::balancermember {
  @@haproxy::balancermember { 'myapp':
    listening_service => 'myapp',
    ports             => ['80','443'],
    server_names      => $::hostname,
    ipaddresses       => $::ipaddress,
    options           => 'check',
  }
}

class profile::appserver (
  $db_pass = lookup('dbpass')
) {
  @@mysql::db { "appdb_${fqdn}":
    user     => 'appuser',
    password => $db_pass,
    host     => $::fqdn,
    grant    => ['SELECT', 'UPDATE', 'CREATE'],
    tag      => ourapp,
  }
}

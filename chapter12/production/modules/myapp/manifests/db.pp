define myapp::db (
  $dbuser,
  $dbpass,
  $dbname = 'wordpress',
){

  class {'::mysql::server':
    root_password    => 'Sup3rp@ssword!',
    override_options => {
      'mysqld' => {
        'bind-address' => '0.0.0.0'
      }
    }
  }

  mysql::db { $dbname:
    user     => $dbuser,
    password => $dbpass,
    host     => '%',
    grant    => ['ALL'],
  }
}
# This produces line is producing 2 values: host and port. We'll use host directly
# on Myapp::Web, but the port designator is used to pass the Resource Type test for
# Database using puppetlabs/app_modeling. Without the port, the test will fail to find
# the upstream Database and won't finish the agent run.
Myapp::Db produces Database {
  host     => $::fqdn,
  port     => '3306',
}

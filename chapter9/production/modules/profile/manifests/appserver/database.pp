class profile::appserver::database {

  class {'::mysql::server':
    root_password => 'suP3rP@ssw0rd!',
  }

  Mysql::Db <<| tag == 'ourapp' |>>
}

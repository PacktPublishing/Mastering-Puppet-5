define myapp::web (
  $webpath,
  $webport,
  $dbuser,
  $dbpass,
  $dbhost,
  $dbname,
  ) {

    package {['php','mysql','php-mysql','php-gd']:
      ensure => installed,
    }

    class {'apache':
      default_vhost => false
    }

    include ::apache::mod::php

    apache::vhost { $::fqdn:
      port    => $webport,
      docroot => $webpath,
      require => [File[$webpath]],
    }

    file { $webpath:
      ensure => directory,
      owner => 'apache',
      group => 'apache',
      require => Package['httpd'],
    }

    class { '::wordpress':
      db_user        => $dbuser,
      db_password    => $dbpass,
      db_host        => $dbhost,
      db_name        => $dbname,
      create_db      => false,
      create_db_user => false,
      install_dir    => $webpath,
      wp_owner       => 'apache',
      wp_group       => 'apache',
    }
  }
Myapp::Web consumes Database { 
  dbhost     => $host,
}
Myapp::Web produces Http {
  host         => $::clientcert,
  port         => $webport,
  ip           => $::networking['interfaces']['enp0s8']['ip'],
  # Like the port parameter in the Database provider, we'll need to send the status_codes
  # flag to the Http provider to ensure we don't only accept a 302 status code.
  # A new wordpress application sends status code 200, so we'll let it through as well.
  status_codes => [302, 200],
}

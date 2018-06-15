class files::hammer {

  $osname = fact('os.name')
  $osrelease = fact('os.release.major')

  concat {'/tmp/hammer.conf':
    ensure => present,
  }

  concat::fragment {'Hammer Time':
    target  => '/tmp/hammer.conf',
    content => "This file is managed by Puppet. It will be overwritten\n",
    order   => '01',
  }

  @@concat::fragment {"${::fqdn}-hammer":
    target => '/tmp/hammer.conf',
    content => "${::fqdn} - ${::ipaddress} - ${osname} ${osrelease}\n",
    order   => '02',
    tag     => 'hammer',
  }

  Concat::Fragment <<| tag == 'hammer' |>>

}

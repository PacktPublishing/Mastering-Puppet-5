class files::scalpel {

  $arch = fact('os.architecture')

  file {'/tmp/scalpel.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => 'This file is editable, with individually managed settings!',
    replace => false,
  }

  @@file_line {"$::fqdn - setting":
    path    => '/tmp/scalpel.conf',
    line    => "${::fqdn}: $arch - ${::kernel} - Virtual: ${::is_virtual}",
    match   => "^${::fqdn}:",
    require => File['/tmp/scalpel.conf'],
    tag    => 'scalpel',
  }

  File_line <<| tag == 'scalpel' |>>

}

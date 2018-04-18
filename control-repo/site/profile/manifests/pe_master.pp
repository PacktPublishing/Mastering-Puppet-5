class profile::pe_master {

  sshkey {'codemanager':
    ensure => present,
    key    => 'Long String of Private Key',
    target => '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa',
    type   => 'ssh-rsa',
  }

  class puppet_enterprise::profile::master {
    code_manager_auto_configure => true,
    r10k_remote                 => 'git@git.ourcompany.com:control-repo.git',
    r10k_private_key            => '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa',
  }

}

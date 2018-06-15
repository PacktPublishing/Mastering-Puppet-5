class profile::etchosts {

# A host record is made containing the FQDN and IP Address of the classified node
  @@host {$::fqdn:
    ensure => present,
    ip     => $facts['networking']['interfaces']['enp0s8']['ip'],
    tag    => ['shoddy_dns'],
  }

# The classified node collects every shoddy_dns host entry, including its own,
# and adds it to the nodes host file. This even works across environments, as
# we haven't isolated it to a single environment.
  Host <<| tag == 'shoddy_dns' |>>
}

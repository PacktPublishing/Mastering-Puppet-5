# = Define: portage::package
#
# Configures and install portage backed packages
#
# == Parameters
#
# [*ensure*]
#
# The ensure value of the package.
#
# [*use*]
#
# Use flags for the package.
#
# [*keywords*]
#
# Portage keywords for the package.
#
# [*target*]
#
# A default value for package.* targets
#
# [*use_target*]
#
# An optional custom target for package use flags
#
# [*keywords_target*]
#
# An optional custom target for package keywords
#
# [*mask_target*]
#
# An optional custom target for package masks
#
# [*unmask_target*]
#
# An optional custom target for package unmasks
#
# [*use_version*]
#
# An optional version specification for package use
#
# [*use_slot*]
#
# An optional slot specification for package use
#
# [*keywords_version*]
#
# An optional version specification for package keywords
#
# [*keywords_slot*]
#
# An optional slot specification for package keywords
#
# [*mask_version*]
#
# An optional version specification for package mask
#
# [*mask_slot*]
#
# An optional slot specification for package mask
#
# [*unmask_version*]
#
# An optional version specification for package unmask
#
# [*unmask_slot*]
#
# An optional slot specification for package unmask
#
# == Example
#
#     portage::package { 'app-admin/puppet':
#       ensure       => '3.0.1',
#       use          => ['augeas', '-rrdtool'],
#       keywords     => '~amd64',
#       target       => 'puppet',
#       mask_version => '<=2.7.18',
#     }
#
# == See Also
#
#  * `puppet describe package_use`
#  * `puppet describe package_keywords`
#  * `puppet describe package_mask`
#  * `puppet describe package_unmask`
#
define portage::package (
  $ensure           = undef,
  $use              = undef,
  $use_version      = undef,
  $use_slot         = undef,
  $keywords         = undef,
  $keywords_version = undef,
  $keywords_slot    = undef,
  $mask_version     = undef,
  $mask_slot        = undef,
  $unmask_version   = undef,
  $unmask_slot      = undef,
  $target           = undef,
  $use_target       = undef,
  $keywords_target  = undef,
  $mask_target      = undef,
  $unmask_target    = undef,
) {

  $atom = $ensure ? {
    /(present|absent|purged|held|installed|latest)/ => $name,
    /./ => "=${name}-${ensure}",
    default => $name,
  }

  if $use_target {
    $assigned_use_target = $use_target
  }
  else {
    $assigned_use_target = $target
  }

  if $keywords_target {
    $assigned_keywords_target = $keywords_target
  }
  else {
    $assigned_keywords_target = $target
  }

  if $mask_target {
    $assigned_mask_target = $mask_target
  }
  else {
    $assigned_mask_target = $target
  }

  if $unmask_target {
    $assigned_unmask_target = $unmask_target
  }
  else {
    $assigned_unmask_target = $target
  }

  if $use {
    package_use { $name:
      use     => $use,
      version => $use_version,
      slot    => $use_slot,
      target  => $assigned_use_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_use { $name:
      ensure => absent,
      target => $assigned_use_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if $keywords or $keywords_version {
    if $keywords == 'all' {
      $assigned_keywords = undef
    }
    else {
      $assigned_keywords = $keywords
    }
    package_keywords { $name:
      keywords => $assigned_keywords,
      version  => $keywords_version,
      slot     => $keywords_slot,
      target   => $assigned_keywords_target,
      notify   => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_keywords { $name:
      ensure => absent,
      target => $assigned_keywords_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if $mask_version or $mask_slot {
    if $mask_version == 'all' {
      $assigned_mask_version = undef
    }
    else {
      $assigned_mask_version = $mask_version
    }
    package_mask { $name:
      version => $assigned_mask_version,
      slot    => $mask_slot,
      target  => $assigned_mask_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_mask { $name:
      ensure => absent,
      target => $assigned_mask_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  if $unmask_version or $unmask_slot {
    if $unmask_version == 'all' {
      $assigned_unmask_version = undef
    }
    else {
      $assigned_unmask_version = $unmask_version
    }
    package_unmask { $name:
      version => $assigned_unmask_version,
      slot    => $unmask_slot,
      target  => $assigned_unmask_target,
      notify  => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }
  else {
    package_unmask { $name:
      ensure => absent,
      target => $assigned_unmask_target,
      notify => [Exec["rebuild_${atom}"], Package[$name]],
    }
  }

  exec { "rebuild_${atom}":
    command     => "emerge --changed-use -u1 ${atom}",
    refreshonly => true,
    timeout     => 43200,
    path        => ['/usr/local/sbin','/usr/local/bin',
                    '/usr/sbin','/usr/bin','/sbin','/bin'],
  }

  package { $name:
    ensure => $ensure,
  }

}

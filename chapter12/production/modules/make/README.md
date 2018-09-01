#make

[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/make.svg)](https://forge.puppetlabs.com/puppet/make)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-make.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-make)
[![Github Tag](https://img.shields.io/github/tag/voxpupuli/puppet-make.svg)](https://github.com/voxpupuli/puppet-make)
[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/voxpupuli/puppet-make?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/puppet/make.svg)](https://forge.puppetlabs.com/puppet/make)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/puppet/make.svg)](https://forge.puppetlabs.com/puppet/make)

####Table of Contents

1. [Overview](#overview)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Parameters](#parameters)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

##Overview

Installs the 'make' package.

##Usage

```puppet
  include ::make
```

To override the package name,

```puppet
  class { '::make':
    package_name => 'gmake',
  }
```

##Parameters

---
#### package_name (type: String)
Name of package for make.

- *Default*: 'make'

---
####package_ensure (type: String)
Value of `ensure` attribute for make package.

- *Default*: 'present'

##Limitations

Supports Puppet v3 and v4 against a matrix of Ruby versions documented
in .travis.yml on the following platforms.

* Debian 7
* EL 5
* EL 6
* EL 7
* SLES/SLED 10
* SLES/SLED 11
* SLES/SLED 12
* Ubuntu 12.04
* Ubuntu 14.04
* Ubuntu 16.04

##Development

To contribute, fork
[https://github.com/voxpupuli/puppet-make.git](https://github.com/voxpupuli/puppet-make.git),
make a branch for your changes, and file a pull request.

##Contributors

Thank you to all of our [https://github.com/voxpupuli/puppet-make/graphs/contributors](https://github.com/voxpupuli/puppet-make/graphs/contributors).

class profile::baseline::linux {

  notify {'baseline': message => 'Applying the Linux Baseline!' }

#  notify {'a':
#    message => 'Resource A',
#    require => Notify['b']
#  }

#  notify {'b':
#    message => 'Resource B',
#    require => Notify['c']
#  }

#  notify {'c':
#    message => 'Resource C',
#    require => Notify['a']
#  }

}

application myapp (
  $dbuser  = 'wordpress',
  $dbpass  = 'w0rdpr3ss!',
  $dbname  = 'wordpress',
  $webpath = '/var/www/wordpress',
  $webport    = '80'
) {

  myapp::db { $name:
    dbuser => $dbuser,
    dbpass => $dbpass,
    dbname => $dbname,
    export => Database["db-${name}"],
  }

# This section can be confusing, but here is essentially what's going on
# $allwebs is an array full of every node assigned to Myapp::Web in our application
# $https takes that $allwebs array of every node, creates a service resource,
# adds myapp::web to each node providing values for that service resource, and then
# returns all transformed service resource names back to the array.

# We're transforming each node listed in our site.pp into an array of Http[<nodename>]
# resource calls. And on each node we'll apply our defined type inside of the
# same map.

  $allwebs = collect_component_titles($nodes, Myapp::Web)

  $https = $allwebs.map |$wordpress_name| {

    $http = Http["web-${wordpress_name}"]

    myapp::web { "$wordpress_name":
      dbuser  => $dbuser,
      dbpass  => $dbpass,
      dbname  => $dbname,
      webport => $webport,
      webpath => $webpath,
      consume => Database["db-${name}"],
      export  => $http,
    }

    $http

  }

# We'll use an each statement here instead of a map, because we don't need
# any Load balancer values returned. They're the end of the chain. Our each
# statement covers each node, and $https from before is used to add nodes
# to the load balancer

  $alllbs = collect_component_titles($nodes, Myapp::Lb)

  $alllbs.each |$load_balancer| {

    myapp::lb { "${load_balancer}":
      balancermembers => $https,
      require         => $https,
      port            => '80',
      balance_mode    => 'roundrobin',
    }

  }

}

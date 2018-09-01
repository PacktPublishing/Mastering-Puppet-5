File.expand_path('../..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/util/webapp'

Puppet::Type.type(:webapp).provide(:webapp) do

  include Puppet::Util::Webapp

  commands :webapp_config => '/usr/sbin/webapp-config'

  confine :operatingsystem => :gentoo
  defaultfor :operatingsystem => :gentoo

  mk_resource_methods

  def self.instances
    webapps = webapp_config('--list-installs').split("\n")
    webapps.collect do |path|
      webapp = Puppet::Util::Webapp::parse_path(path)
      opts = Puppet::Util::Webapp::build_opts(webapp, '--show-installed')
      app = webapp_config(opts)
      new(
        webapp.
          merge(Puppet::Util::Webapp::parse_app(app)).
          merge({:ensure => :present})
      )
    end
  end

  def self.prefetch(resources)
    webapps = instances
    resources.keys.each do |name|
      if provider = webapps.find { |webapp| webapp.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    webapp = parse_resource(resource)
    opts = build_opts(webapp, '--install')
    webapp_config(opts)
  end

  def destroy
    webapp = parse_resource(resource)
    opts = build_opts(webapp, '--clean')
    webapp_config(opts)
  end
end

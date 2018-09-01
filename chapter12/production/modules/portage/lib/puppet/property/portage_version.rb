File.expand_path('../..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/util/portage'
require 'puppet/property'

class Puppet::Property::PortageVersion < Puppet::Property
  desc "A properly formatted version string"

  validate do |value|
    unless Puppet::Util::Portage.valid_version? value
      raise ArgumentError, "#{name} must be a properly formatted version"
    end
  end
end

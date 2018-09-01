File.expand_path('../..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/util/portage'
require 'puppet/parameter'

class Puppet::Parameter::PortageName < Puppet::Parameter
  desc "The package name"

  validate do |value|

    unless Puppet::Util::Portage.valid_package? value
      raise ArgumentError, "#{name} must be a properly formatted atom, see portage(5) for more information"
    end
  end
end

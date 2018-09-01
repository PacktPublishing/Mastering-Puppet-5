File.expand_path('../..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_use).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.use/default",
  :filetype => :flat
) do

  desc "The package_use provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name use}, :joiner => ' ', :rts => true do |line|
    Puppet::Provider::PortageFile.process_line(line, :use)
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed
    build_line(hash, :use)
  end
end

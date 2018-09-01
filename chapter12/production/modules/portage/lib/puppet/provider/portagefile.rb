# Common base class for gentoo package_* providers. It aggregates some of the
# boilerplate that's shared between the providers.
File.expand_path('..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/util/portage'
require 'puppet/provider/parsedfile'
class Puppet::Provider::PortageFile < Puppet::Provider::ParsedFile

  text_line :comment, :match => /^#/;
  text_line :blank, :match => /^\s*$/;

  def flush
    # Ensure the target directory exists before creating file
    unless File.exist?(dir = File.dirname(target))
      Dir.mkdir(dir)
    end
    super
    File.chmod(0644, target)
  end

  def self.build_line(hash, sym = nil)
    unless hash[:name] and hash[:name] != :absent
      raise ArgumentError, "name is a required attribute of portagefile providers"
    end

    str = Puppet::Util::Portage.format_atom(hash)

    if !sym.nil? and hash.include? sym
      if hash[sym].is_a? Array
        str << " " << hash[sym].join(" ")
      else
        str << " " << hash[sym]
      end
    end
    str
  end

  # Define the :process FileRecord hook
  #
  # @param [String] line
  # @param [Symbol] attribute
  #
  # @return [Hash]
  def self.process_line(line, attribute = nil)
    hash = {}

    if !attribute.nil? and (match = line.match /^(\S+)\s+(.*)\s*$/)
      # if we have a package and an array of attributes.

      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      if components[:compare] and components[:version]
        v = components[:compare] + components[:version]
      end

      hash[:name]    = components[:package]
      hash[:version] = v

      if components[:slot]
        hash[:slot] = components[:slot].dup
      end

      attr_array = match[2].split(/\s+/)
      hash[attribute] = attr_array

    elsif (match = line.match /^(\S+)\s*/)
      # just a package
      components = Puppet::Util::Portage.parse_atom(match[1])

      # Try to parse version string
      if components[:compare] and components[:version]
        v = components[:compare] + components[:version]
      end

      hash[:name]    = components[:package]
      hash[:version] = v

      if components[:slot]
        hash[:slot] = components[:slot].dup
      end

    else
      raise Puppet::Error, "Could not match '#{line}'"
    end

    hash
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed
    build_line(hash)
  end
end

Puppet::Type.type(:layman).provide(:layman) do

  desc "The layman provider to manage overlays"

  commands :layman => '/usr/bin/layman'

  confine :operatingsystem => :gentoo
  defaultfor :operatingsystem => :gentoo

  def self.instances
    overlays.collect do |name|
      new({
        :name   => name,
        :ensure => :present,
      })
    end
  end

  def self.prefetch(resources)
    overlays = instances
    resources.keys.each do |name|
      if provider = overlays.find { |overlay| overlay.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    layman_args = []
    if resource[:overlay_list]
      layman_args.push('-o',resource[:overlay_list])
    end
    layman_args.push('--add', resource[:name])
    self.class.run_layman(layman_args)
    @property_hash[:ensure] = :present
  end

  def destroy
    self.class.run_layman('--delete', resource[:name])
    @property_hash[:ensure] = :absent
  end

  def self.run_layman(*args)
    layman('--nocolor', '--quiet', args)
  end

  def self.overlays
    run_layman('--list-local').
      split("\n").
      map { |x| x.match(OVERLAY_PATTERN) }.
      compact.
      map { |x| x[1] }
  end

  OVERLAY_PATTERN = '\s+\*\s+(\S+).+' unless const_defined?(:OVERLAY_PATTERN)
end

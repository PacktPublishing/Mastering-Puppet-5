require 'puppet_integration/tmpdir_manager'

module PuppetIntegration
  module Files
    extend Forwardable
    def_delegator PuppetIntegration::TmpdirManager.instance, :tmpfile
    def_delegator PuppetIntegration::TmpdirManager.instance, :tmpdir
    extend self
  end
end

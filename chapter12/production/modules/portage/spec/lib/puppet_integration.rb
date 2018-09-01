require 'rspec'
require 'puppet'
require 'puppet_integration/tmpdir_manager'
require 'puppet_integration/files'
require 'puppet_integration/fixtures'

RSpec.configure do |config|

  include PuppetIntegration::Files

  config.before(:all) do
    PuppetIntegration::TmpdirManager.instance.prepare

    Puppet[:vardir]  = PuppetIntegration::TmpdirManager.instance.tmpdir 'vardir'
    Puppet[:statedir]= PuppetIntegration::TmpdirManager.instance.tmpdir 'statedir'
    Puppet[:confdir] = PuppetIntegration::TmpdirManager.instance.tmpdir 'confdir'
    Puppet[:logdir]  = PuppetIntegration::TmpdirManager.instance.tmpdir 'logdir'
  end

  config.after(:all) do
    PuppetIntegration::TmpdirManager.instance.cleanup
  end
end

require 'spec_helper'

require 'support/integration/provider/shared_examples'
require 'support/integration/provider/shared_contexts'

describe Puppet::Type.type(:package_unmask).provider(:parsed) do
  include_context "portagefile integration runner"
  it_behaves_like "a portagefile mask provider"
end

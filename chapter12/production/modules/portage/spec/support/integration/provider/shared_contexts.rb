require 'spec_helper'

shared_context "portagefile integration runner" do
  let(:path) { PuppetIntegration::TmpdirManager.instance.tmpfile }
  let(:type_class) { described_class.resource_type }

  around(:each) do |example|
    described_class.stubs(:header).returns ''

    catalog = Puppet::Resource::Catalog.new
    resources.each { |r| catalog.add_resource r }

    catalog.apply
    example.run

    catalog.clear
    described_class.clear
  end

  subject { File.read(path) }
end

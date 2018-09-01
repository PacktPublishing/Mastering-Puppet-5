require 'spec_helper'

describe Puppet::Type.type(:layman) do
  before do
    @provider = stub 'provider'
    @provider.stubs(:name).returns(:layman)
    described_class.stubs(:defaultprovider).returns(@provider)
  end

  describe "when validating attributes" do
    params     = [:name,:overlay_list]
    properties = [:ensure]

    params.each do |param|
      it "should have the #{param} param" do
        described_class.attrtype(param).should == :param
      end
    end

    properties.each do |property|
      it "should have the #{property} property" do
        described_class.attrtype(property).should == :property
      end
    end
  end

  it "should have name as the namevar" do
    described_class.key_attributes.should == [:name]
  end
end

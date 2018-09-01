require 'spec_helper'

describe Puppet::Type.type(:package_mask) do
  before do
    @provider = stub 'provider'
    @provider.stubs(:name).returns(:parsed)
    @provider.stubs(:ancestors).returns([Puppet::Provider::ParsedFile])
    @provider.stubs(:default_target).returns("defaulttarget")
    described_class.stubs(:defaultprovider).returns(@provider)
  end

  describe "when validating attributes" do
    params     = [:name]
    properties = [:target, :ensure, :version, :slot]

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

  describe "when validating the target property" do
    it "should default to the provider's default target" do
      described_class.new(:name => "sys-devel/gcc").should(:target).should == "/etc/portage/package.mask/defaulttarget"
    end

    it "should munge targets that do not specify a fully qualified path" do
      described_class.new(:name => "sys-devel/gcc", :target => "gcc").should(:target).should == "/etc/portage/package.mask/gcc"
    end

    it "should not munge fully qualified targets" do
      described_class.new(:name => "sys-devel/gcc", :target => "/tmp/gcc").should(:target).should == "/tmp/gcc"
    end
  end
end

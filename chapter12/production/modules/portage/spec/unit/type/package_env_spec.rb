require 'spec_helper'

describe Puppet::Type.type(:package_env) do
  before do
    @provider = stub 'provider'
    @provider.stubs(:name).returns(:parsed)
    @provider.stubs(:ancestors).returns([Puppet::Provider::ParsedFile])
    @provider.stubs(:default_target).returns("defaulttarget")
    described_class.stubs(:defaultprovider).returns(@provider)
  end

  describe "when validating attributes" do
    params     = [:name]
    properties = [:env, :target, :ensure, :version, :slot]

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

  describe "when validating the env property" do
    it "should accept a string for env" do
      expect { described_class.new(:name => "www-client/firefox", :env => "no-lto") }.to_not raise_error
    end

    it "should accept an array for env" do
      expect { described_class.new(:name => "www-client/firefox", :env => ["distcc","no-lto"]) }.to_not raise_error
    end
  end

  describe "when validating the target property" do
    it "should default to the provider's default target" do
      described_class.new(:name => "www-client/firefox").should(:target).should == "/etc/portage/package.env/defaulttarget"
    end

    it "should munge targets that do not specify a fully qualified path" do
      described_class.new(:name => "www-client/firefox", :target => "firefox").should(:target).should == "/etc/portage/package.env/firefox"
    end

    it "should not munge fully qualified targets" do
      described_class.new(:name => "www-client/firefox", :target => "/tmp/firefox").should(:target).should == "/tmp/firefox"
    end
  end

  describe "when validating the env property" do
    it "should default to an empty list" do
      described_class.new(:name => "sys-devel/gcc").should(:env).should == []
    end

    it "should properly handle nested arrays" do
      described_class.new(:name => "sys-devel/gcc", :env => ["foo",["bar"]]).property(:env).insync?(["foo","bar"]).should be_true
    end
  end
end

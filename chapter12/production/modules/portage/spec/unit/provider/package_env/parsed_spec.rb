require 'spec_helper'

describe Puppet::Type.type(:package_env).provider(:parsed) do
  before do
    described_class.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    described_class.stubs(:filetype=)
    @default_target = described_class.default_target
  end

  it "should have a default target of /etc/portage/package.env/default" do
    described_class.default_target.should == "/etc/portage/package.env/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree doc"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with version" do
      line = ">=app-admin/tree-2.0-r1 doc"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with slot" do
      line = "app-admin/tree:2 doc"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should not raise an error if no env fields are given for a package" do
      line = "app-admin/tree"
      lambda { described_class.parse_line(line) }.should_not raise_error
    end

    it "should parse out a single env field" do
      line = "app-admin/tree doc"
      described_class.parse_line(line)[:env].should == %w{doc}
    end

    it "should parse out multiple env fields into an array" do
      line = "app-admin/tree doc debug"
      described_class.parse_line(line)[:env].should == %w{doc debug}
    end
  end

  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.env').returns(true)
      described_class.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_env.new(:name => 'app-admin/tree')
      resource.stubs(:should).with(:target).returns(@default_target)

      @providerinstance = described_class.new(resource)
      @providerinstance.ensure = :present
    end

    after :each do
      described_class.clear
    end

    it "should write an atom name to disk" do
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree\n"
    end

    it "should write a single env to disk" do
      @providerinstance.env = "doc"
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree doc\n"
    end

    it "should write an array of env to disk" do
      @providerinstance.env = %w{doc bin}
      @providerinstance.flush
      @ramfile.read.should == "app-admin/tree doc bin\n"
    end
  end
end

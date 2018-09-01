require 'spec_helper'

describe Puppet::Type.type(:package_mask).provider(:parsed) do
  before do
    described_class.stubs(:filetype).returns(Puppet::Util::FileType::FileTypeRam)
    described_class.stubs(:filetype=)
    @default_target = described_class.default_target
  end

  it "should have a default target of /etc/portage/package.mask/default" do
    described_class.default_target.should == "/etc/portage/package.mask/default"
  end

  describe "when parsing" do

    it "should parse out the package name" do
      line = "app-admin/tree"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with version" do
      line = ">=app-admin/tree-2.0-r1"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end

    it "should parse out the package name with slot" do
      line = "app-admin/tree:2"
      described_class.parse_line(line)[:name].should == "app-admin/tree"
    end
  end

  describe "when flushing" do
    before :each do
      @ramfile = Puppet::Util::FileType::FileTypeRam.new(@default_target)
      File.stubs(:exist?).with('/etc/portage/package.mask').returns(true)
      described_class.any_instance.stubs(:target_object).returns(@ramfile)

      resource = Puppet::Type::Package_mask.new(:name => 'app-admin/tree')
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
  end
end

require 'spec_helper'

require 'support/integration/provider/shared_contexts'

describe Puppet::Type.type(:package_use).provider(:parsed) do

  include_context "portagefile integration runner"

  subject { File.read(path) }

  describe "with a single instance" do
    describe "without a version or slot" do
      describe "without a keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :target   => path,
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^app-admin/dummy $] }
      end

      describe "with a single keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => 'doc',
            :target   => path,
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^app-admin/dummy doc$] }
      end

      describe "with multiple use" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => ['acpi', 'sse2'],
            :target   => path,
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^app-admin/dummy acpi sse2$] }
      end
    end
    describe "with a version and slot" do
      describe "without a keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :target   => path,
            :version  => '>=2.3.4_alpha1',
            :slot     => '2',
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^>=app-admin/dummy-2\.3\.4_alpha1:2 $] }
      end

      describe "with a single keyword" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => 'doc',
            :target   => path,
            :version  => '>=2.3.4_alpha1',
            :slot     => '2',
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^>=app-admin/dummy-2\.3\.4_alpha1:2 doc$] }
      end

      describe "with multiple use" do
        let(:resources) do
          r = []
          r << type_class.new(
            :name     => 'app-admin/dummy',
            :use      => ['acpi', 'sse2'],
            :target   => path,
            :version  => '>=2.3.4_alpha1',
            :slot     => '2',
            :provider => :parsed
          )
          r
        end

        it { should have(1).lines }
        it { should match %r[^>=app-admin/dummy-2\.3\.4_alpha1:2 acpi sse2$] }
      end
    end
  end
end

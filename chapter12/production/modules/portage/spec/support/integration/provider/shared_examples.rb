require 'spec_helper'

shared_examples "a portagefile mask provider" do

  describe "with single instance" do

    describe "without a version or slot" do
      let(:resources) do
        # Well this is fucking cryptic.
        r = []
        r << type_class.new(
          :name     => 'app-admin/dummy',
          :target   => path,
          :provider => :parsed
        )
        r
      end

      it { should have(1).lines }
      it { should match %r[^app-admin/dummy$] }
    end

    describe "with a version and slot" do
      let(:resources) do
        r = []
        r << type_class.new(
          :name     => 'app-admin/dummy',
          :target   => path,
          :version  => '>=3.1.2-r1',
          :slot     => '3',
          :provider => :parsed
        )
        r
      end

      it { should have(1).lines }
      it { should match %r[^>=app-admin/dummy-3.1.2-r1:3$] }
    end
  end

  describe "with multiple instances" do

    describe "without a version" do
      let(:resources) do
        r = []
        r << type_class.new(
          :name     => 'app-admin/first',
          :target   => path,
          :provider => :parsed
        )
        r << type_class.new(
          :name     => 'app-admin/second',
          :target   => path,
          :provider => :parsed
        )

        r
      end

      it { should have(2).lines }
      it { should match %r[^app-admin/first$] }
      it { should match %r[^app-admin/second$] }
    end
  end
end

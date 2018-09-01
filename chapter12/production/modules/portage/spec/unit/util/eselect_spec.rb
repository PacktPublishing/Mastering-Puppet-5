require 'spec_helper'

require 'puppet/util/eselect'

describe Puppet::Util::Eselect do
  describe "module" do

    modules = ["foo", "ruby", "python::python2"]
    fields = {
      :command => Symbol,
      :flags   => Array,
      :param   => String,
      :get     => Array,
      :set     => Array,
      :parse   => Proc,
    }
    keys = fields.keys
    valid_commands = Puppet::Util::Eselect::COMMANDS.keys

    modules.each do |name|
      mod = Puppet::Util::Eselect.module(name)

      describe "the #{name} eselect module" do
        keys.each do |key|
          it "should include #{key}" do
            mod.should include key
          end
          it "should have a #{fields[key]} for #{key}" do
            mod[key].should be_a(fields[key])
          end
        end

        it "should use a valid command" do
          valid_commands.should include(mod[:command])
        end

        it "should have a unary parse method" do
          mod[:parse].arity.should be(1)
        end

        it "should have different get and set actions" do
          mod[:get].should_not be(mod[:set])
        end
      end
    end

    describe "the gcc eselect module" do
      mod = Puppet::Util::Eselect.module("gcc")
      it "should use the command gcc-config" do
        mod[:command].should be(:gcc_config)
      end
      it "should not have a param" do
        mod[:params].should be_nil
      end
    end
  end
end

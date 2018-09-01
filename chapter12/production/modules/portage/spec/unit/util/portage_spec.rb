require 'spec_helper'

require 'puppet/util/portage'

describe Puppet::Util::Portage do
  describe "valid_atom?" do

    valid_atoms = [
      '=foo/bar-1.0.0',
      '>=foo/bar-1.0.0',
      '<=foo/bar-1.0.0',
      '>foo/bar-1.1.0',
      '<foo/bar-1.0.0',
      'foo1-bar2/messy_atom++',
      'foo/bar:1',
      '=foo/bar-1.0.0:1',
      '>=foo/bar-1.0.0:1',
      '<=foo/bar-1.0.0:1',
      '>foo/bar-1.1.0:1',
      '<foo/bar-1.0.0:1',
      'foo/bar-1.0*',
      '=foo/bar-1.0*',
      'foo/bar-1.0*:1',
      '=foo/bar-1.0*:1',
    ]

    invalid_atoms = [
      'sys-devel-gcc',
      '=sys-devel/gcc',
      # version without quantifier
      'foo1-bar2/messy_atom++-1.0',
      # slot with quantifier
      '=sys-devel/gcc:4.8',
      '>sys-devel/gcc-4.8*',
      '=sys-devel/gcc-4.8.*',
    ]

    valid_atoms.each do |atom|
      it "should accept '#{atom}' as a valid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_true
      end
    end

    invalid_atoms.each do |atom|
      it "should reject #{atom} as an invalid name" do
        Puppet::Util::Portage.valid_atom?(atom).should be_false
      end
    end
  end

  describe "valid_package?" do
    valid_packages = [
      'app-accessibility/brltty',
      'dev-libs/userspace-rcu',
      'sys-dev/gcc',
      'x11-wm/aewm++',
      'x11-themes/fvwm_sounds',
      'net-analyzer/nagios-check_logfiles',
      'dev-embedded/scratchbox-toolchain-cs2005q3_2-glibc2_5',
      'virtual/package-manager',
    ]

    invalid_packages = [
      'gcc',
      'sys-dev-gcc',
      '=app-admin/eselect-fontconfig-1.1',
      'sys-devel/gcc:4.8',
      '>sys-devel/gcc-4.8.0:4.8',
    ]

    valid_packages.each do |package|
      it "should accept #{package} as valid" do
        Puppet::Util::Portage.valid_package?(package).should be_true
      end
    end

    invalid_packages.each do |package|
      it "should reject #{package} as invalid" do
        Puppet::Util::Portage.valid_package?(package).should be_false
      end
    end
  end

  describe "valid_version?" do
    comparators = %w{~ < > = <= >=}

    valid_versions = [
      '4.3.2-r4',
      '1.3',
      '0.5.2_pre20120527',
      '3.0_alpha12',
    ]

    invalid_versions = [
      '!4.3.2-r4',
      '4.2.3>',
      'alpha',
      'alpha-2.4.1'
    ]

    valid_wildcards = [
      '2.2*',
      '5.1_alpha*',
      '1.2-r1*'
    ]

    invalid_wildcards = [
      '2.2.*',
      '5.1-al*',
      '3.*.0',
      '1.2-r*',
    ]

    (valid_versions + valid_wildcards).each do |ver|
      it "should accept #{ver} as valid" do
        Puppet::Util::Portage.valid_version?(ver).should be_true
      end
    end

    describe 'with comparators' do
      version_strings = valid_versions.map { |ver|
        comparators.map { |comp| comp + ver }
      }.flatten + valid_wildcards.map { |ver| '=' + ver }

      version_strings.each do |ver|
        it "should accept #{ver} as valid" do
          Puppet::Util::Portage.valid_version?(ver).should be_true
        end
      end
    end

    (invalid_versions + invalid_wildcards).each do |ver|
      it "should reject #{ver} as invalid" do
        Puppet::Util::Portage.valid_version?(ver).should be_false
      end
    end
  end

  describe "valid_slot?" do
    operators = %w{= * %s= %s/%s}

    valid_slots = [
      '_',
      'a',
      '4.8',
      'live',
      'stable',
      'alpha-3',
      'alpha+beta'
    ]

    invalid_slots = [
      '',
      '!3',
      '~alpha',
      '>4.8',
      '>=4.8',
    ]

    valid_slots.each do |slot|
      it "should accept #{slot} as valid" do
        Puppet::Util::Portage.valid_slot?(slot).should be_true
      end
    end

    describe 'with slot operators' do
      slots_with_operators = Set.new
      operators.each do |oper|
        valid_slots.each do |slot|
          valid_slots.each do |subslot|
            slot_str = oper % [slot, subslot]
            slots_with_operators << slot_str
          end
        end
      end
      slots_with_operators.each do |slot_str|
        it "should accept #{slot_str} as valid" do
          Puppet::Util::Portage.valid_slot?(slot_str).should be_true
        end
      end
    end

    invalid_slots.each do |slot|
      it "should reject #{slot} as invalid" do
        Puppet::Util::Portage.valid_slot?(slot).should be_false
      end
    end
  end

  describe "parse_atom" do

    valid_base_atoms = [
      'app-accessibility/brltty',
      'dev-libs/userspace-rcu',
      'sys-dev/gcc',
    ]

    valid_base_atoms.each do |atom|
      it "should parse #{atom} as {:package => #{atom}}" do
        Puppet::Util::Portage.parse_atom(atom).should == {:package => atom}
      end
    end

    valid_atoms = [
      {
        :atom => '=dev-libs/glib-2.32.4-r1',
        :expected => {
          :package => 'dev-libs/glib',
          :version => '2.32.4-r1',
          :compare => '=',
        },
      },
      {
        :atom => '>=app-admin/puppet-3.0.1',
        :expected => {
          :package => 'app-admin/puppet',
          :version => '3.0.1',
          :compare => '>=',
        }
      },
      {
        :atom => '=app-misc/dummy-2-2.5-r2',
        :expected => {
          :package => 'app-misc/dummy-2',
          :version => '2.5-r2',
          :compare => '=',
        }
      },
      {
        :atom => '~sys-apps/net-tools-1.60_p20120127084908',
        :expected => {
          :package => 'sys-apps/net-tools',
          :version => '1.60_p20120127084908',
          :compare => '~',
        }
      },
      {
        :atom => '<sys-devel/libtool-2.4-r1',
        :expected => {
          :package => 'sys-devel/libtool',
          :version => '2.4-r1',
          :compare => '<',
        }
      },
      {
        :atom => '>=x11-proto/xproto-7.0.23-r1',
        :expected => {
          :package => 'x11-proto/xproto',
          :version => '7.0.23-r1',
          :compare => '>=',
        }
      },
      {
        :atom => 'www-client/chromium:live',
        :expected => {
          :package => 'www-client/chromium',
          :slot    => 'live',
        }
      },
      {
        :atom => '<www-plugins/chrome-binary-plugins-9999:unstable',
        :expected => {
          :package => 'www-plugins/chrome-binary-plugins',
          :version => '9999',
          :compare => '<',
          :slot    => 'unstable',
        }
      },
      {
        :atom => '>=sys-devel/gcc-4.8.1:4.8',
        :expected => {
          :package => 'sys-devel/gcc',
          :version => '4.8.1',
          :compare => '>=',
          :slot    => '4.8',
        }
      },
      {
        :atom => '=dev-lang/ghc-7.6.3:0/7.6.3',
        :expected => {
          :package => 'dev-lang/ghc',
          :version => '7.6.3',
          :compare => '=',
          :slot    => '0/7.6.3',
        }
      },
      {
        :atom => '=sys-apps/portage-2.2*',
        :expected => {
          :package => 'sys-apps/portage',
          :version => '2.2*',
          :compare => '=',
        }
      },
      {
        :atom => 'sys-devel/gcc-4.5*',
        :expected => {
          :package => 'sys-devel/gcc',
          :version => '4.5*',
          :compare => '',
        }
      },
      {
        :atom => '=sys-devel/gcc-4.5*:4.5',
        :expected => {
          :package => 'sys-devel/gcc',
          :version => '4.5*',
          :compare => '=',
          :slot    => '4.5',
        }
      },
    ]

    valid_atoms.each do |atom|
      atom_str = atom[:atom]
      atom_hash = atom[:expected]
      it "should parse #{atom_str} as #{atom_hash}" do
        Puppet::Util::Portage.parse_atom(atom_str).should == atom_hash
      end
    end

    invalid_atoms = [
      'gcc',
      'sys-dev-gcc',
      '=app-admin/eselect-fontconfig',
      '!app-accessibility/brltty-4.3.2-r4',
      '<dev-libs/userspace-rcu4.1.2',
      '>=sys-dev/gcc-alpha4.5.1',
      '>=sys-devel/gcc-r1',
      '<=sys-devel/gcc:4.8',
      '>=app-misc/dummy-0.3:!',
      'sys-devel/gcc-*',
      'sys-devel/gcc-4.5.*',
      '>=sys-devel/gcc-4.5*',
    ]

    invalid_atoms.each do |atom|
      it "should raise an error when parsing #{atom}" do
        expect {
          Puppet::Util::Portage.parse_atom(atom)
        }.to raise_error, Puppet::Util::Portage::AtomError
      end
    end
  end

  describe "parse_cmpver" do
    valid_cmpvers = [
      {
        :cmpver => '2.3.4-r1',
        :expected => {
          :compare => '=',
          :version => '2.3.4-r1',
        },
      },
      {
        :cmpver => '>=12995_alpha13',
        :expected => {
          :compare => '>=',
          :version => '12995_alpha13',
        },
      },
      {
        :cmpver => '=0.30*',
        :expected => {
          :compare => '=',
          :version => '0.30*',
        },
      },
    ]

    valid_cmpvers.each do |cmpver|
      cmpver_str = cmpver[:cmpver]
      cmpver_hash = cmpver[:expected]
      it "should parse #{cmpver_str} as #{cmpver_hash}" do
        Puppet::Util::Portage.parse_cmpver(cmpver_str).should == cmpver_hash
      end
    end

    invalid_cmpvers = [
      '*',
      '4.5.*',
      '0.3:!',
      '0-beta1',
    ]

    invalid_cmpvers.each do |cmpver|
      it "should raise an error when parsing #{cmpver}" do
        expect {
          Puppet::Util::Portage.parse_cmpver(cmpver)
        }.to raise_error, Puppet::Util::Portage::AtomError
      end
    end
  end
end

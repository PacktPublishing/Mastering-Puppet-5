require 'spec_helper'

describe 'make', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      context 'make class without any parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('make') }

        it { is_expected.to contain_package('make').with_ensure('present') }
      end
    end
  end

  describe 'on "unsupported" operating system' do
    context 'overriding package_name parameter on FreeBSD' do
      let :params do
        {
          package_name: 'gmake'
        }
      end
      let :facts do
        {
          osfamily: 'FreeBSD',
          operatingsystem: 'FreeBSD'
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('make') }

      it { is_expected.to contain_package('gmake').with_ensure('present') }
    end
  end
end

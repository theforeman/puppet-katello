require 'spec_helper'

describe 'katello' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('katello::repo') }
      it { is_expected.to contain_class('katello::candlepin') }
      it { is_expected.to contain_class('katello::application') }
      it { is_expected.to contain_class('katello::pulp') }
      it { is_expected.to contain_class('katello::qpid_client') }
      it { is_expected.to contain_class('katello::qpid') }

      it { is_expected.to contain_package('katello').that_requires('Exec[cpinit]') }
    end
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        :concat_basedir            => '/tmp',
        :hostname                  => 'localhost',
        :operatingsystem           => 'UNSUPPORTED OPERATINGSYSTEM',
        :operatingsystemmajrelease => '1',
        :operatingsystemrelease    => '1',
        :osfamily                  => 'UNSUPPORTED OSFAMILY',
        :root_home                 => '/root'
      }
    end

    it { expect { should contain_class('katello') }.to raise_error(Puppet::Error, /#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/) }
  end
end

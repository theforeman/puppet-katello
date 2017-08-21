require 'spec_helper'

describe 'katello' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('katello::repo') }
        it { is_expected.to contain_class('katello::candlepin') }
        it { is_expected.to contain_class('katello::application') }
        it { is_expected.to contain_class('katello::pulp') }
        it { is_expected.to contain_class('katello::qpid') }

        it { is_expected.to contain_package('katello').that_requires('Exec[cpinit]') }
      end

      context 'only candlepin' do
        let :params do
          {
            manage_candlepin: true,
            manage_qpid: false,
            manage_pulp: false,
            manage_foreman_application: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('katello::candlepin') }
        it { is_expected.not_to contain_class('katello::repo') }
        it { is_expected.not_to contain_class('katello::application') }
        it { is_expected.not_to contain_class('foreman') }
        it { is_expected.not_to contain_class('katello::pulp') }
        it { is_expected.not_to contain_class('pulp') }
        it { is_expected.not_to contain_class('katello::qpid') }
        it { is_expected.not_to contain_class('qpid') }
      end

      context 'only qpid' do
        let :params do
          {
            manage_candlepin: false,
            manage_qpid: true,
            manage_pulp: false,
            manage_foreman_application: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('katello::candlepin') }
        it { is_expected.not_to contain_class('katello::repo') }
        it { is_expected.not_to contain_class('katello::application') }
        it { is_expected.not_to contain_class('foreman') }
        it { is_expected.not_to contain_class('katello::pulp') }
        it { is_expected.not_to contain_class('pulp') }
        it { is_expected.to contain_class('katello::qpid') }
        it { is_expected.to contain_class('qpid') }
      end

      context 'only pulp' do
        let :params do
          {
            manage_candlepin: false,
            manage_qpid: false,
            manage_pulp: true,
            manage_foreman_application: false,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('katello::candlepin') }
        it { is_expected.not_to contain_class('katello::repo') }
        it { is_expected.not_to contain_class('katello::application') }
        it { is_expected.not_to contain_class('foreman') }
        it { is_expected.to contain_class('katello::pulp') }
        it { is_expected.to contain_class('pulp') }
        it { is_expected.not_to contain_class('katello::qpid') }
        it { is_expected.not_to contain_class('qpid') }
      end

      context 'only application' do
        let :params do
          {
            manage_candlepin: false,
            manage_qpid: false,
            manage_pulp: false,
            manage_foreman_application: true,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('katello::candlepin') }
        it { is_expected.to contain_class('katello::repo') }
        it { is_expected.to contain_class('katello::application') }
        it { is_expected.to contain_class('foreman') }
        it { is_expected.not_to contain_class('katello::pulp') }
        it { is_expected.not_to contain_class('pulp') }
        it { is_expected.not_to contain_class('katello::qpid') }
        it { is_expected.not_to contain_class('qpid') }
      end
    end
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        concat_basedir: '/tmp',
        hostname: 'localhost',
        operatingsystem: 'UNSUPPORTED OPERATINGSYSTEM',
        operatingsystemmajrelease: '1',
        operatingsystemrelease: '1',
        osfamily: 'UNSUPPORTED OSFAMILY',
        root_home: '/root'
      }
    end

    it { expect { should contain_class('katello') }.to raise_error(Puppet::Error, /#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/) }
  end
end

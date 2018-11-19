require 'spec_helper'

describe 'katello::candlepin' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let (:facts) { facts }

      context 'with explicit parameters' do
        let(:params) do
          {
            :user_groups    => ['foreman'],
            :oauth_key      => 'candlepin',
            :oauth_secret   => 'secret',
            :db_host        => 'localhost',
            :db_port        => 5432,
            :db_name        => 'candlepin',
            :db_user        => 'candlepin',
            :db_password    => 'secret',
            :db_ssl         => false,
            :db_ssl_verify  => true,
            :manage_db      => true,
            :qpid_hostname  => 'localhost',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::candlepin').that_notifies('Service[tomcat]') }
        it { is_expected.to contain_class('candlepin') }
      end

      context 'with inherited parameters' do
        let :pre_condition do
          'include katello'
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::candlepin').that_notifies('Service[tomcat]') }
        it { is_expected.to contain_class('candlepin') }
      end
    end
  end
end

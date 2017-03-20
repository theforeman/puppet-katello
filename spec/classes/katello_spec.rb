require 'spec_helper'

describe 'katello' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      let(:pre_condition) do
        ['include foreman', 'include certs']
      end

      it { should contain_class('katello::install') }
      it { should contain_class('katello::config') }

      it "should configure a qpid client" do
        should contain_class('qpid::client').
          with(:ssl             => true,
               :ssl_cert_name   => 'broker')
      end

      context 'on setting cdn-ssl-version' do
        let :params do
          {
            "cdn_ssl_version" => 'TLSv1'
          }
        end

        it 'should set up the cdn_ssl_version' do
          should contain_file('/etc/foreman/plugins/katello.yaml').
            with_content(/^\s*:cdn_ssl_version:\s*TLSv1$/)
        end
      end

      context 'on setting qpid_host' do
        let :params do
          {
            :qpid_host => 'other.qpid.host.com'
          }
        end

        it 'should set up qpid_url' do
          should contain_file('/etc/foreman/plugins/katello.yaml').
            with_content(/^\s*:url:\s*amqp:ssl:other.qpid.host.com:5671$/)
        end
      end

      context 'on setting pulp_host' do
        let :params do
          {
            :pulp_host => 'other.pulp.host.com'
          }
        end

        it 'should set up pulp_url' do
          should contain_file('/etc/foreman/plugins/katello.yaml').
            with_content(%r{^\s*:url:\s*https://other.pulp.host.com/pulp/api/v2/$})
        end
      end

      context 'on setting candlepin_host' do
        let :params do
          {
            :candlepin_host => 'other.candlepin.host.com'
          }
        end

        it 'should set up candlepin_url' do
          should contain_file('/etc/foreman/plugins/katello.yaml').
            with_content(%r{^\s*:url:\s*https://other.candlepin.host.com:8443/candlepin$})
        end
      end
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

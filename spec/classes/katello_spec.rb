require 'spec_helper'

describe 'katello' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to contain_class('katello::candlepin') }
      it { is_expected.to contain_class('katello::application') }
      it { is_expected.to contain_class('katello::pulp') }
      it { is_expected.to contain_class('katello::qpid_client') }
      it { is_expected.to contain_class('katello::qpid') }

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

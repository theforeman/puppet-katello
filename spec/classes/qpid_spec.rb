require 'spec_helper'

describe 'katello::qpid' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        let(:pre_condition) do
          <<-PUPPET
          class { 'katello::globals':
            enable_katello_agent => false,
          }
          PUPPET
        end

        it do
          is_expected.to create_class('qpid')
            .with_ensure('absent')
            .with_ssl(false)
            .with_ssl_cert_db(nil)
            .with_ssl_cert_password_file(nil)
            .with_ssl_cert_name(nil)
        end

        it { is_expected.not_to create_qpid__config__queue('katello.agent') }
      end

      context 'with overridden parameters' do
        let :params do
          {
            wcache_page_size: 8,
          }
        end

        it 'should pass the variable' do
          is_expected.to compile.with_all_deps
          is_expected.to create_class('qpid').with_wcache_page_size(8)
        end
      end

      context 'with enable_katello_agent true' do
        let(:pre_condition) do
          <<-PUPPET
          class { 'katello::globals':
            enable_katello_agent => true,
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::qpid').that_notifies(['Service[qpidd]', 'Class[qpid]']) }
        it { is_expected.to create_class('qpid').with_wcache_page_size(4).with_interface('lo') }

        it do
          is_expected.to create_qpid__config__queue('katello.agent')
            .with_ssl_cert('/etc/foreman/client_cert.pem')
            .with_ssl_key('/etc/foreman/client_key.pem')
        end
      end

    end
  end
end

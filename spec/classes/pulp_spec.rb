require 'spec_helper'

describe 'katello::pulp' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(processorcount: 1) }

      context 'with default parameters' do
        context 'minimal set' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('certs') }
          # pulp-server creates the pulp group which qpid_client uses
          it { is_expected.to contain_class('certs::qpid_client').that_requires('Package[pulp-server]').that_notifies('Service[pulp_workers]') }

          it do
            is_expected.to create_class('pulp')
              .with_messaging_url('ssl://localhost:5671')
              .with_messaging_ca_cert('/etc/pki/pulp/qpid/ca.crt')
              .with_messaging_client_cert('/etc/pki/pulp/qpid/client.crt')
              .with_messaging_transport('qpid')
              .with_messaging_auth_enabled(false)
              .with_broker_url('qpid://localhost:5671')
              .with_broker_use_ssl(true)
              .with_yum_max_speed(nil)
              .with_manage_broker(false)
              .with_manage_httpd(false)
              .with_manage_plugins_httpd(true)
              .with_manage_squid(true)
              .with_enable_rpm(true)
              .with_enable_iso(true)
              .with_enable_puppet(true)
              .with_enable_docker(true)
              .with_enable_ostree(false)
              .with_num_workers(1)
              .with_enable_parent_node(false)
              .with_repo_auth(true)
              .with_puppet_wsgi_processes(1)
              .with_enable_katello(true)
              .with_manage_db(true)
              .with_db_name('pulp_database')
              .with_db_seeds('localhost:27017')
              .with_db_ssl(false)
          end

          it do
            is_expected.to create_foreman__config__apache__fragment('pulp')
              .with_content(%r{^<Location /pulp>$})
              .with_ssl_content(%r{^<Location /pulp/api>$})
          end

          it { is_expected.to create_anchor('katello::pulp').that_requires('Class[pulp]') }

          context 'with repo present' do
            let(:pre_condition) { 'include katello::repo' }

            it 'is expected to set up requirements' do
              is_expected.to compile.with_all_deps
              is_expected.to contain_anchor('katello::repo')
              is_expected.to create_class('pulp').that_requires(['Anchor[katello::repo]', 'Yumrepo[katello]'])
            end
          end
        end

        context 'with database parameters' do
          let :params do
            {
              mongodb_name: 'pulp_db',
              mongodb_username: 'pulp_user',
              mongodb_password: 'pulp_pw',
              mongodb_seeds: '192.168.1.1:27017',
            }
          end

          it do
            is_expected.to compile.with_all_deps
            is_expected.to create_class('pulp')
              .with_db_name('pulp_db')
              .with_db_username('pulp_user')
              .with_db_password('pulp_pw')
              .with_db_seeds('192.168.1.1:27017')
          end

          context 'with manage_httpd => true' do
            let :params do
              super().merge({ 'manage_httpd' => true, })
            end

            it do
              is_expected.to create_class('pulp')
                .with_manage_httpd(true)
            end
          end
        end
      end
    end
  end
end

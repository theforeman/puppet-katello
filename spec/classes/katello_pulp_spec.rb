require 'spec_helper'

describe 'katello::pulp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with inherited parameters' do
        let :pre_condition do
          <<-EOS
          class { '::katello':
            num_pulp_workers  => 1,
          }
          EOS
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs') }
        it { is_expected.to contain_class('certs::qpid_client') }

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
            .that_subscribes_to('Class[Certs::Qpid_client]')
        end

        it do
          is_expected.to create_foreman__config__apache__fragment('pulp')
            .with_content(%r{^<Location /pulp>$})
            .with_ssl_content(%r{^<Location /pulp/api>$})
        end

        it { is_expected.to create_file('/var/lib/pulp') }

        it do
          is_expected.to create_file('/var/lib/pulp/katello-export')
            .with_ensure('directory')
            .with_owner('foreman')
            .with_group('foreman')
            .with_mode('0755')
        end
      end

      context 'with explicit parameters' do
        let :pre_condition do
          <<-EOS
          class { '::katello':
            pulp_db_name      => 'pulp_db',
            pulp_db_username  => 'pulp_user',
            pulp_db_password  => 'pulp_pw',
            pulp_db_seeds     => '192.168.1.1:27017'
          }
          EOS
        end

        it do
          is_expected.to create_class('pulp')
            .with_db_name('pulp_db')
            .with_db_username('pulp_user')
            .with_db_password('pulp_pw')
            .with_db_seeds('192.168.1.1:27017')
        end
      end
    end
  end
end

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
            oauth_secret     => 'secret',
            num_pulp_workers => 1,
          }
          EOS
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs') }
        it { is_expected.to contain_class('certs::qpid_client') }
        it { is_expected.to contain_class('katello::candlepin') }

        it do
          is_expected.to create_class('pulp')
            .with_oauth_enabled(true)
            .with_oauth_key('katello')
            .with_oauth_secret('secret')
            .with_messaging_url('ssl://localhost:5671')
            .with_messaging_ca_cert('/etc/pki/katello/certs/katello-default-ca.crt')
            .with_messaging_client_cert('/etc/pki/katello/qpid_client_striped.crt')
            .with_messaging_transport('qpid')
            .with_messaging_auth_enabled(false)
            .with_broker_url('qpid://localhost:5671')
            .with_broker_use_ssl(true)
            .with_consumers_crl('/var/lib/candlepin/candlepin-crl.crl')
            .with_proxy_url(nil)
            .with_proxy_port(nil)
            .with_proxy_username(nil)
            .with_proxy_password(nil)
            .with_yum_max_speed(nil)
            .with_manage_broker(false)
            .with_manage_httpd(false)
            .with_manage_plugins_httpd(true)
            .with_manage_squid(true)
            .with_enable_rpm(true)
            .with_enable_puppet(true)
            .with_enable_docker(true)
            .with_enable_ostree(false)
            .with_num_workers(1)
            .with_max_tasks_per_child(2)
            .with_enable_parent_node(false)
            .with_repo_auth(true)
            .with_puppet_wsgi_processes(1)
            .with_enable_katello(true)
            .that_subscribes_to('Class[Certs::Qpid_client]')
        end

        it do
          is_expected.to create_foreman__config__passenger__fragment('pulp')
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
    end
  end
end

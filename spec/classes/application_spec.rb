require 'spec_helper'

describe 'katello::application' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let (:params) { {} }

      let(:pre_condition) do
        <<-PUPPET
        class { 'katello::params':
          candlepin_oauth_secret => 'candlepin-secret',
        }
        PUPPET
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_package('tfm-rubygem-katello') }
        it { is_expected.not_to create_package('tfm-rubygem-katello').that_requires('Anchor[katello::candlepin]') }
        it { is_expected.to contain_class('certs::qpid') }
        it { is_expected.to contain_class('katello::qpid_client') }

        it do
          is_expected.to create_foreman_config_entry('pulp_client_cert')
            .with_value('/etc/pki/katello/certs/pulp-client.crt')
            .that_requires(['Class[Certs::Pulp_client]', 'Foreman::Rake[db:seed]'])
        end

        it do
          is_expected.to create_foreman_config_entry('pulp_client_key')
            .with_value('/etc/pki/katello/private/pulp-client.key')
            .that_requires(['Class[Certs::Pulp_client]', 'Foreman::Rake[db:seed]'])
        end

        it do
          is_expected.to contain_service('httpd')
            .that_subscribes_to(['Class[Certs::Apache]', 'Class[Certs::Ca]'])
        end

        it do
          is_expected.to contain_file('/etc/foreman/plugins/katello.yaml')
            .that_notifies(['Class[Foreman::Service]', 'Exec[foreman-rake-db:seed]'])
        end

        it do
          is_expected.to create_foreman__config__apache__fragment('katello')
            .without_content()
            .with_ssl_content(%r{^<LocationMatch /rhsm\|/katello/api>$})
        end

        it do
          is_expected.to contain_class('certs::qpid')
            .that_notifies(['Class[Foreman::Plugin::Tasks]'])
        end

        it do
          is_expected.to contain_foreman__dynflow__worker('worker-hosts-queue')
        end

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', [
            ':katello:',
            '  :rest_client_timeout: 3600',
            '  :content_types:',
            '    :yum: true',
            '    :file: true',
            '    :deb: true',
            '    :puppet: true',
            '    :docker: true',
            '    :ostree: false',
            '  :candlepin:',
            '    :url: https://localhost:8443/candlepin',
            '    :oauth_key: "katello"',
            '    :oauth_secret: "candlepin-secret"',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :pulp:',
            '    :url: https://foo.example.com/pulp/api/v2/',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
            '  :use_pulp_2_for_content_type:',
            '    :docker: false',
            '    :file: false',
            '  :qpid:',
            '    :url: amqp:ssl:localhost:5671',
            '    :subscriptions_queue_address: katello_event_queue',
            '  :container_image_registry:',
            '    :crane_url: https://foo.example.com:5000',
            '    :crane_ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt'
          ])
        end

        it do
          is_expected.to create_file('/var/lib/pulp/katello-export')
            .with_ensure('directory')
            .with_owner('foreman')
            .with_group('foreman')
            .with_mode('0755')
            .that_requires('Exec[mkdir -p /var/lib/pulp/katello-export]')
        end
      end

      context 'with repo present' do
        let(:pre_condition) { 'include katello::repo' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_package('tfm-rubygem-katello').that_requires(['Anchor[katello::repo]', 'Yumrepo[katello]']) }
      end

      context 'with parameters' do
        let(:params) do
          {
            rest_client_timeout: 4000,
            cdn_ssl_version: 'TLSv1',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', [
            ':katello:',
            '  :cdn_ssl_version: TLSv1',
            '  :rest_client_timeout: 4000',
            '  :content_types:',
            '    :yum: true',
            '    :file: true',
            '    :deb: true',
            '    :puppet: true',
            '    :docker: true',
            '    :ostree: false',
            '  :candlepin:',
            '    :url: https://localhost:8443/candlepin',
            '    :oauth_key: "katello"',
            '    :oauth_secret: "candlepin-secret"',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :pulp:',
            '    :url: https://foo.example.com/pulp/api/v2/',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
            '  :use_pulp_2_for_content_type:',
            '    :docker: false',
            '    :file: false',
            '  :qpid:',
            '    :url: amqp:ssl:localhost:5671',
            '    :subscriptions_queue_address: katello_event_queue',
            '  :container_image_registry:',
            '    :crane_url: https://foo.example.com:5000',
            '    :crane_ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
          ])
        end
      end

      context 'with inherited parameters' do
        let :pre_condition do
          <<-EOS
          class {'katello::globals':
            enable_ostree => true,
          }
          #{super()}
          EOS
        end

        it { is_expected.to compile.with_all_deps }

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', [
            ':katello:',
            '  :rest_client_timeout: 3600',
            '  :content_types:',
            '    :yum: true',
            '    :file: true',
            '    :deb: true',
            '    :puppet: true',
            '    :docker: true',
            '    :ostree: true',
            '  :candlepin:',
            '    :url: https://localhost:8443/candlepin',
            '    :oauth_key: "katello"',
            '    :oauth_secret: "candlepin-secret"',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :pulp:',
            '    :url: https://foo.example.com/pulp/api/v2/',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
            '  :use_pulp_2_for_content_type:',
            '    :docker: false',
            '    :file: false',
            '  :qpid:',
            '    :url: amqp:ssl:localhost:5671',
            '    :subscriptions_queue_address: katello_event_queue',
            '  :container_image_registry:',
            '    :crane_url: https://foo.example.com:5000',
            '    :crane_ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt'
          ])
        end
      end

      context 'with candlepin' do
        let(:pre_condition) { super() + 'include katello::candlepin' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_package('tfm-rubygem-katello').that_requires('Anchor[katello::candlepin]') }
      end

      context 'with pulp' do
        # post condition because things are compile order dependent
        let(:post_condition) { 'include katello::pulp' }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_exec('mkdir -p /var/lib/pulp/katello-export').that_requires(['Anchor[katello::pulp]']) }
      end
    end
  end
end

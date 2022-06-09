require 'spec_helper'

describe 'katello::application' do
  on_supported_os.each do |os, facts|
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

        if facts[:operatingsystemmajrelease] == '7'
          it { is_expected.to create_package('tfm-rubygem-katello') }
          it { is_expected.not_to create_package('tfm-rubygem-katello').that_requires('Anchor[katello::candlepin]') }
          it { is_expected.to create_package('rh-postgresql12-postgresql-evr') }
        else
          it { is_expected.to create_package('rubygem-katello') }
          it { is_expected.not_to create_package('rubygem-katello').that_requires('Anchor[katello::candlepin]') }
          it { is_expected.to create_package('postgresql-evr') }
        end

        it do
          is_expected.to contain_service('httpd')
            .that_subscribes_to(['Class[Certs::Apache]', 'Class[Certs::Ca]'])
        end

        it do
          is_expected.to contain_file('/etc/foreman/plugins/katello.yaml')
            .that_notifies('Class[Foreman::Service]')
            .that_comes_before('Foreman::Rake[db:seed]')
        end

        it do
          is_expected.to create_foreman__config__apache__fragment('katello')
            .without_content()
            .with_ssl_content(%r{^<LocationMatch /rhsm\|/katello/api>$})
        end

        it { is_expected.to contain_foreman__dynflow__pool('worker-hosts-queue').with_instances(1) }
        it { is_expected.to contain_foreman__dynflow__worker('worker-hosts-queue') }

        let(:katello_yaml_content) do
          [
            ':katello:',
            '  :rest_client_timeout: 3600',
            '  :candlepin:',
            '    :url: https://localhost:23443/candlepin',
            '    :oauth_key: "katello"',
            '    :oauth_secret: "candlepin-secret"',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :candlepin_events:',
            '    :ssl_cert_file: /etc/foreman/client_cert.pem',
            '    :ssl_key_file: /etc/foreman/client_key.pem',
            '    :ssl_ca_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :agent:',
            '    :enabled: false',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end

      context 'with repo present' do
        let(:pre_condition) { 'include katello::repo' }

        it { is_expected.to compile.with_all_deps }

        if facts[:operatingsystemmajrelease] == '7'
          it { is_expected.to create_package('tfm-rubygem-katello').that_requires(['Anchor[katello::repo]', 'Yumrepo[katello]']) }
        else
          it { is_expected.to create_package('rubygem-katello').that_requires(['Anchor[katello::repo]', 'Yumrepo[katello]']) }
        end
      end

      context 'with parameters' do
        let(:params) do
          {
            rest_client_timeout: 4000,
          }
        end

        it { is_expected.to compile.with_all_deps }

        let(:katello_yaml_content) do
          [
            '  :rest_client_timeout: 4000',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end

      context 'with inherited parameters' do
        let :pre_condition do
          <<-EOS
          class {'katello::globals':
            enable_katello_agent => true,
          }
          #{super()}
          EOS
        end

        it { is_expected.to compile.with_all_deps }

        let(:katello_yaml_content) do
          [
            ':katello:',
            '  :rest_client_timeout: 3600',
            '  :candlepin:',
            '    :url: https://localhost:23443/candlepin',
            '    :oauth_key: "katello"',
            '    :oauth_secret: "candlepin-secret"',
            '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :candlepin_events:',
            '    :ssl_cert_file: /etc/foreman/client_cert.pem',
            '    :ssl_key_file: /etc/foreman/client_key.pem',
            '    :ssl_ca_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '  :agent:',
            '    :enabled: true',
            '    :broker_url: amqps://localhost:5671',
            '    :broker_ssl_cert_file: /etc/foreman/client_cert.pem',
            '    :broker_ssl_key_file: /etc/foreman/client_key.pem',
            '    :broker_ssl_ca_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '    :event_queue_name: katello.agent',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end

      context 'with RH repo url set' do
        let(:params) do
          {
            redhat_repository_url: 'https://foo.example.com',
          }
        end

        it { is_expected.to compile.with_all_deps }

        let(:katello_yaml_content) do
          [
            '  :redhat_repository_url: https://foo.example.com',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end

      context 'with candlepin' do
        let(:pre_condition) { super() + 'include katello::candlepin' }

        it { is_expected.to compile.with_all_deps }

        if facts[:operatingsystemmajrelease] == '7'
          it { is_expected.to create_package('tfm-rubygem-katello').that_requires('Anchor[katello::candlepin]') }
        else
          it { is_expected.to create_package('rubygem-katello').that_requires('Anchor[katello::candlepin]') }
        end
      end

      context 'with katello::globals parameter as an empty string' do
        let :pre_condition do
          <<-EOS
          class {'katello::globals':
            enable_katello_agent => '',
          }
          EOS
        end

        it { is_expected.to compile.with_all_deps }

        it 'should generate correct katello.yaml' do
          is_expected.to contain_file('/etc/foreman/plugins/katello.yaml').with_content(%r{:enabled: true})
        end
      end

      context 'with katello::globals::enable_katello_agent true' do
        let :pre_condition do
          <<-EOS
          class {'katello::globals':
            enable_katello_agent => true,
          }
          EOS
        end

        it { is_expected.to compile.with_all_deps }

        let(:katello_yaml_content) do
          [
            '  :agent:',
            '    :enabled: true',
            '    :broker_url: amqps://localhost:5671',
            '    :broker_ssl_cert_file: /etc/foreman/client_cert.pem',
            '    :broker_ssl_key_file: /etc/foreman/client_key.pem',
            '    :broker_ssl_ca_file: /etc/pki/katello/certs/katello-default-ca.crt',
            '    :event_queue_name: katello.agent',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end
    end
  end
end

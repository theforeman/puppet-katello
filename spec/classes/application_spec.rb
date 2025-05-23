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

        it { is_expected.to create_package('rubygem-katello') }
        it { is_expected.not_to create_package('rubygem-katello').that_requires('Anchor[katello::candlepin]') }

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
            '    :ca_cert_file: /etc/foreman/proxy_ca.pem',
            '  :candlepin_events:',
            '    :ssl_cert_file: /etc/foreman/client_cert.pem',
            '    :ssl_key_file: /etc/foreman/client_key.pem',
            '    :ssl_ca_file: /etc/foreman/proxy_ca.pem',
          ]
        end

        it 'should generate correct katello.yaml' do
          verify_exact_contents(catalogue, '/etc/foreman/plugins/katello.yaml', katello_yaml_content)
        end
      end

      context 'with repo present' do
        let(:pre_condition) do
          <<~PUPPET
            class { 'katello::repo':
              repo_version => 'nightly',
            }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to create_package('rubygem-katello').that_requires(['Anchor[katello::repo]', 'Yumrepo[katello]']) }
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

      context 'with candlepin' do
        let(:pre_condition) { super() + 'include katello::candlepin' }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to create_package('rubygem-katello').that_requires('Anchor[katello::candlepin]') }
      end
    end
  end
end

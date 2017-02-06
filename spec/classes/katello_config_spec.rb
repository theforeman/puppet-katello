require 'spec_helper'

describe 'katello::config' do
  on_os_under_test.each do |os, facts|
    let(:facts) { facts }

    context 'default config settings' do
      let(:pre_condition) do
        [
          'include foreman',
          'include certs',
          'class {"katello":' \
            'post_sync_token => test_token,' \
            'oauth_secret   => secret' \
          '}'
        ]
      end

      it 'should NOT set the cdn-ssl-version' do
        should_not contain_file('/etc/foreman/plugins/katello.yaml').
          with_content(/cdn_ssl_version/)
      end

      it 'should generate correct katello.yaml' do
        should contain_file('/etc/foreman/plugins/katello.yaml')
        verify_exact_contents(catalogue,  '/etc/foreman/plugins/katello.yaml', [
          ':katello:',
          '  :rest_client_timeout: 3600',
          '  :post_sync_url: https://foo.example.com/katello/api/v2/repositories/sync_complete?token=test_token',
          '  :candlepin:',
          '    :url: https://foo.example.com:8443/candlepin',
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
          '  :pulp:',
          "    :url: https://#{facts[:fqdn]}/pulp/api/v2/",
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '    :ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
          '  :qpid:',
          "    :url: amqp:ssl:localhost:5671",
          '    :subscriptions_queue_address: katello_event_queue'
        ])
      end
    end

    context 'when http proxy parameters are specified' do
      let(:pre_condition) do
        [
          'include foreman',
          'include certs',
          'class {"katello":' \
            'post_sync_token => "test_token",' \
            'oauth_secret    => "secret",' \
            'proxy_url       => "http://myproxy.org",' \
            'proxy_port      => 8888,' \
            'proxy_username  => "admin",' \
            'proxy_password  => "secret_password"' \
          '}'
        ]
      end

      it 'should generate correct katello.yaml' do
        should contain_file('/etc/foreman/plugins/katello.yaml')
        verify_exact_contents(catalogue,  '/etc/foreman/plugins/katello.yaml', [
          ':katello:',
          '  :rest_client_timeout: 3600',
          '  :post_sync_url: https://foo.example.com/katello/api/v2/repositories/sync_complete?token=test_token',
          '  :candlepin:',
          '    :url: https://foo.example.com:8443/candlepin',
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '    :ca_cert_file: /etc/pki/katello/certs/katello-default-ca.crt',
          '  :pulp:',
          "    :url: https://#{facts[:fqdn]}/pulp/api/v2/",
          '    :oauth_key: katello',
          '    :oauth_secret: secret',
          '    :ca_cert_file: /etc/pki/katello/certs/katello-server-ca.crt',
          '  :qpid:',
          "    :url: amqp:ssl:localhost:5671",
          '    :subscriptions_queue_address: katello_event_queue',
          '  :cdn_proxy:',
          '    :host: http://myproxy.org',
          '    :port: 8888',
          '    :user: admin',
          '    :password: secret_password'
        ])
      end
    end
  end
end

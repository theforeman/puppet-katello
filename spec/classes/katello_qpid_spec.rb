require 'spec_helper'

describe 'katello::qpid' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with explicit parameters' do
        let :params do
          {
            :katello_user            => 'foreman',
            :candlepin_event_queue   => 'katello_event_queue',
            :candlepin_qpid_exchange => 'event',
            :wcache_page_size        => 8,
            :interface               => 'eth0',
            :hostname                => 'localhost',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs') }
        it { is_expected.to contain_class('certs::qpid').that_notifies(['Service[qpidd]', 'Class[qpid]']) }
        it { is_expected.not_to contain_user('foreman') }

        it do
          is_expected.to create_class('qpid')
            .with_wcache_page_size(8)
            .with_interface('eth0')
        end

        it do
          is_expected.to create_qpid__config_cmd('delete katello entitlements queue if bound to *.*')
            .with_command('del queue katello_event_queue --force')
            .with_onlyif("list binding | grep katello_event_queue | grep '*.*'")
            .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
            .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
        end

        it do
          is_expected.to create_qpid__config__queue('katello_event_queue')
            .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
            .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
        end

        ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created'].each do |binding|
          it do
            is_expected.to create_qpid__config__bind(binding)
              .with_queue('katello_event_queue')
              .with_exchange('event')
              .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
              .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
          end
        end
      end

      context 'with inherited parameters' do
        let :pre_condition do
          'include ::katello'
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_user('foreman').with_groups(['puppet', 'qpidd']) }
        it { is_expected.to contain_class('certs::qpid').that_notifies(['Service[qpidd]', 'Class[qpid]']) }

        it do
          is_expected.to create_class('qpid')
            .with_wcache_page_size(4)
        end

        it do
          is_expected.to create_qpid__config_cmd('delete katello entitlements queue if bound to *.*')
            .with_command('del queue katello_event_queue --force')
            .with_onlyif("list binding | grep katello_event_queue | grep '*.*'")
            .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
            .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
        end

        it do
          is_expected.to create_qpid__config__queue('katello_event_queue')
            .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
            .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
        end

        ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created'].each do |binding|
          it do
            is_expected.to create_qpid__config__bind(binding)
              .with_queue('katello_event_queue')
              .with_exchange('event')
              .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
              .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
          end
        end
      end
    end
  end
end

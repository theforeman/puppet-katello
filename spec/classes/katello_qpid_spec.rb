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
          }
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_class('qpid')
            .with_wcache_page_size(8)
            .with_interface('eth0')
        end

        it { is_expected.to contain_class('certs::qpid').that_notifies('Service[qpidd]') }
      end

      context 'with inherited parameters' do
        let :pre_condition do
          'include ::katello'
        end

        it { is_expected.to compile.with_all_deps }

        it do
          is_expected.to contain_class('qpid')
            .with_wcache_page_size(4)
            .with_interface('lo')
        end

        it { is_expected.to contain_class('certs::qpid').that_notifies(['Service[qpidd]', 'Class[qpid]']) }
      end
    end
  end
end

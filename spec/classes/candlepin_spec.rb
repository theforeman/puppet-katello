require 'spec_helper'

describe 'katello::candlepin' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let (:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::candlepin').that_notifies('Service[tomcat]') }
        it { is_expected.to create_class('candlepin') }
        it { is_expected.not_to contain_class('candlepin').that_requires('Anchor[katello::qpid::event_queue]') }
      end

      context 'with qpid parameters' do
        let(:pre_condition) { 'include katello::qpid' }

        it 'should require a complete event queue' do
          is_expected.to compile.with_all_deps
          is_expected.to contain_anchor('katello::qpid::event_queue')
          is_expected.to create_class('candlepin').that_requires('Anchor[katello::qpid::event_queue]')
        end
      end
    end
  end
end

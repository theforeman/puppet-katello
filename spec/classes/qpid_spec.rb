require 'spec_helper'

describe 'katello::qpid' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::qpid').that_notifies(['Service[qpidd]', 'Class[qpid]']) }
        it { is_expected.to create_class('qpid').with_wcache_page_size(4).with_interface('lo') }
      end

      it do
        is_expected.to create_qpid__config__queue('katello.agent --sasl-mechanism=EXTERNAL')
          .with_ssl_cert('/etc/pki/katello/certs/foo.example.com-qpid-broker.crt')
          .with_ssl_key('/etc/pki/katello/private/foo.example.com-qpid-broker.key')
      end

      context 'with overridden parameters' do
        let :params do
          {
            wcache_page_size: 8,
          }
        end

        it 'should pass the variable' do
          is_expected.to compile.with_all_deps
          is_expected.to create_class('qpid').with_wcache_page_size(8)
        end
      end
    end
  end
end

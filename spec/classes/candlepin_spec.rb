require 'spec_helper'

describe 'katello::candlepin' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) { facts }

      describe 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::candlepin').that_notifies('Service[tomcat]') }
        it { is_expected.to contain_class('candlepin').with_artemis_client_dn('CN=foo.example.com, OU=PUPPET, O=FOREMAN, ST=North Carolina, C=US') }
      end
    end
  end
end

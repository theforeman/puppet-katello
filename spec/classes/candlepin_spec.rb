require 'spec_helper'

describe 'katello::candlepin' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let (:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('certs::candlepin').that_notifies('Service[tomcat]') }
        it { is_expected.to create_class('candlepin') }
      end
    end
  end
end

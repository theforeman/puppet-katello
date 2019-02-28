require 'spec_helper'

describe 'katello' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('katello::repo') }
      it { is_expected.to contain_class('katello::candlepin') }
      it { is_expected.to contain_class('katello::application') }
      it { is_expected.to contain_class('katello::pulp') }
      it { is_expected.to contain_class('katello::qpid_client') }
      it { is_expected.to contain_class('katello::qpid') }

      it { is_expected.to contain_package('katello').that_requires('Class[candlepin]') }

      it { is_expected.to contain_service('tomcat').that_requires('Qpid::Config::Bind[entitlement.created]') }
    end
  end
end

require 'spec_helper'

describe 'katello' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('katello::candlepin').with_artemis_client_dn('CN=foo.example.com, OU=PUPPET, O=FOREMAN, ST=North Carolina, C=US') }
      it { is_expected.to contain_class('katello::application') }
      it { is_expected.to contain_package('rubygem-katello').that_requires('Class[candlepin]') }
      it { is_expected.to contain_package('katello') }

      context 'with facts_match_regex' do
        let(:params) { { candlepin_facts_match_regex: 'test_match_regex' } }

        it { is_expected.to compile.with_all_deps }

        it 'should pass the facts_match_regex parameter to katello::candlepin' do
          is_expected.to contain_class('katello::candlepin').with_facts_match_regex('test_match_regex')
        end
      end
    end
  end
end

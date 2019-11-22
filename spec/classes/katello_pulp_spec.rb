require 'spec_helper'

describe 'katello::pulp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with inherited parameters' do
        let(:pre_condition) { 'include katello' }

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to create_foreman__config__apache__fragment('pulp')
            .with_content(%r{^<Location /pulp>$})
            .with_ssl_content(%r{^<Location /pulp/api>$})
        end

        it { is_expected.to create_file('/var/lib/pulp') }

        it do
          is_expected.to create_file('/var/lib/pulp/katello-export')
            .with_ensure('directory')
            .with_owner('foreman')
            .with_group('foreman')
            .with_mode('0755')
        end
      end
    end
  end
end

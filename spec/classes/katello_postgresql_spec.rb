require 'spec_helper'

describe 'katello::postgresql' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('postgresql::server') }
      end

      context 'with config entries and hba rules' do
        let :params do
          {
            :config_entries => {
              'log_min_duration_statement' => 2000,
              'max_connections'            => 42,
            },
            :pg_hba_rules => {
              'local admin' => {
                'type'        => 'local',
                'database'    => 'all',
                'user'        => 'admin',
                'order'       => 1,
                'auth_method' => 'trust',
              },
            },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('postgresql::server') }
        it { is_expected.to contain_postgresql__server__config_entry('log_min_duration_statement').with_value(2000) }
        it { is_expected.to contain_postgresql__server__config_entry('max_connections').with_value(42) }

        it do
          is_expected.to contain_postgresql__server__pg_hba_rule('local admin'). \
            with_type('local'). \
            with_database('all'). \
            with_user('admin'). \
            with_order(1). \
            with_auth_method('trust')
        end
      end
    end
  end
end

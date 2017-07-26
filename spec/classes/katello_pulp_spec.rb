require 'spec_helper'

describe 'katello::pulp' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let :pre_condition do
        'include ::katello'
      end

      it { is_expected.to compile.with_all_deps }
    end
  end
end

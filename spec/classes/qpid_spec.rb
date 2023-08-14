require 'spec_helper'

describe 'katello::qpid' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with default parameters' do
        it do
          is_expected.to create_class('qpid')
            .with_ensure('absent')
            .with_ssl(false)
        end

        it { is_expected.not_to create_qpid__config__queue('katello.agent') }
      end
    end
  end
end

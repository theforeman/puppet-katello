require 'spec_helper_acceptance'

describe 'Uninstall qpid' do
  before(:context) { purge_katello }

  context 'with default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include katello::qpid
        PUPPET
      end
    end

    describe service('qpidd') do
      it { is_expected.not_to be_running }
      it { is_expected.not_to be_enabled }
    end

    describe port('5671') do
      it { is_expected.not_to be_listening }
    end

    describe port('5672') do
      it { is_expected.not_to be_listening }
    end

    describe package('qpid-cpp-server') do
      it { is_expected.not_to be_installed }
    end
  end
end

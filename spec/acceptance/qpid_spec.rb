require 'spec_helper_acceptance'

describe 'Install qpid' do
  context 'with enable_katello_agent true' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'katello::globals':
          enable_katello_agent => true,
        }
        include katello::qpid
        PUPPET
      end
    end

    describe service('qpidd') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port('5671') do
      it { is_expected.to be_listening }
    end

    describe port('5672') do
      it { is_expected.to be_listening }
    end
  end

  context 'with enable_katello_agent false' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'katello::globals':
          enable_katello_agent => false,
        }
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

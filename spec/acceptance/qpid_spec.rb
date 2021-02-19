require 'spec_helper_acceptance'

describe 'Install Candlepin' do
  let(:pp) { 'include katello::qpid' }

  it_behaves_like 'a idempotent resource'

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

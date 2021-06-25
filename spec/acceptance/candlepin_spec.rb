require 'spec_helper_acceptance'

describe 'Install Candlepin' do
  before(:context) { purge_katello }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) { 'include katello::candlepin' }
  end

  describe service('tomcat') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port('23443') do
    it { is_expected.to be_listening }
  end

  describe command('curl -k -s -o /dev/null -w \'%{http_code}\' https://localhost:23443/candlepin/status') do
    its(:stdout) { should eq "200" }
  end
end

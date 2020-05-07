require 'spec_helper_acceptance'

describe 'Install Candlepin' do
  let(:pp) { 'include katello::candlepin' }

  it_behaves_like 'a idempotent resource'

  describe service('tomcat') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe port('8443') do
    it { is_expected.to be_listening }
  end

  describe command('curl -k -s -o /dev/null -w \'%{http_code}\' https://localhost:8443/candlepin/status') do
    its(:stdout) { should eq "200" }
  end
end

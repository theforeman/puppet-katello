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

  describe file("/usr/share/tomcat/conf/cert-users.properties") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'tomcat' }
    it { should be_grouped_into 'tomcat' }
    its(:content) { should eq("katelloUser=CN=#{fact('fqdn')}, OU=PUPPET, O=FOREMAN, ST=North Carolina, C=US\n") }
  end
end

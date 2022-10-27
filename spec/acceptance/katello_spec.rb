require 'spec_helper_acceptance'

describe 'Scenario: install katello' do
  before(:context) { purge_katello }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
        include katello
        include foreman::cli
      PUPPET
    end
  end

  [
    'httpd',
    'dynflow-sidekiq@orchestrator',
    'dynflow-sidekiq@worker-1',
    'foreman',
    'tomcat',
  ].each do |service_name|
    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe file('/run/foreman.sock') do
    it { should be_socket }
  end

  describe command('hammer --version') do
    its(:stdout) { is_expected.to match(/^hammer/) }
  end

  describe file("/usr/share/tomcat/conf/cert-users.properties") do
    its(:content) { should eq("katelloUser=CN=#{fact('fqdn')}, OU=PUPPET, O=FOREMAN, ST=North Carolina, C=US\n") }
  end
end

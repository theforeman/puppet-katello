require 'spec_helper_acceptance'

describe 'qpid installation' do
  include_examples 'the example', 'qpid_standalone.pp'

  describe service('qpidd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(5671) do
    it { is_expected.to be_listening }
  end
end

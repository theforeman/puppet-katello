require 'spec_helper'

describe 'katello::build_dn' do
  it 'should exist' do
    is_expected.not_to eq(nil)
  end

  it 'should compute dn' do
    is_expected.to run.with_params([['a', '1'], ['b', '2']]).and_return("a=1, b=2")
  end

  it 'should compute dn and ignore empty values' do
    is_expected.to run.with_params([['a', nil], ['b', '2']]).and_return("b=2")
  end

  it 'should ignore empty strings' do
    is_expected.to run.with_params([['a', ''], ['b', '2']]).and_return("b=2")
  end
end

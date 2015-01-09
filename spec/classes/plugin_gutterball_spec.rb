require 'spec_helper'

describe 'katello::plugin::gutterball' do
  let :facts do
    {
      :concat_basedir             => '/tmp',
      :operatingsystem            => 'RedHat',
      :operatingsystemrelease     => '6.4',
      :operatingsystemmajrelease  => '6',
      :osfamily                   => 'RedHat',
    }
  end

  let :pre_condition do
      "class {['certs', 'foreman', 'katello']: }"
  end

  context 'foreman::plugin_prefix => undef' do
    let :foreman do
      { :plugin_prefix => nil }
    end

    it { should contain_class('certs::gutterball') }

    it { should contain_class('gutterball') }

    it { should contain_package('ruby193-rubygem-foreman_gutterball') }
  end

 context 'foreman::plugin_prefix => present' do
   it { should contain_class('certs::gutterball') }

   it 'should call the plugin' do
     should contain_foreman__plugin('gutterball')
   end

   it { should contain_class('gutterball') }
 end
end

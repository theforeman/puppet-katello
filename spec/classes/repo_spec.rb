require 'spec_helper'

describe 'katello::repo' do
  context 'with default parameters' do
    let(:facts) { { operatingsystemmajrelease: '7' } }

    it do
      is_expected.to contain_yumrepo('katello')
        .with_descr('katello latest')
        .with_baseurl("https://fedorapeople.org/groups/katello/releases/yum/latest/katello/el7/\$basearch/")
        .with_gpgkey('absent')
        .with_gpgcheck(false)
        .with_enabled(true)
    end
  end

  context 'with manage_repo => true' do
    let :params do
      {
        'repo_version' => '3.14',
        'dist'         => 'el8',
        'gpgcheck'     => true,
        'gpgkey'       => 'https://yum.theforeman.org/releases/1.24/RPM-GPG-KEY-foreman',
      }
    end

    it do
      is_expected.to contain_yumrepo('katello')
        .with_descr('katello 3.14')
        .with_baseurl("https://fedorapeople.org/groups/katello/releases/yum/3.14/katello/el8/\$basearch/")
        .with_gpgkey('https://yum.theforeman.org/releases/1.24/RPM-GPG-KEY-foreman')
        .with_gpgcheck(true)
        .with_enabled(true)
    end
  end
end

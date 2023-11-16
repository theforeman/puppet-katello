require 'spec_helper'

describe 'katello::repo' do
  let(:facts) { { os: { release: { major: '8' } } } }

  context 'with default parameters' do
    it { is_expected.to compile.and_raise_error(//) }
  end

  context 'with nightly repo' do
    let :params do
      {
        'repo_version' => 'nightly',
      }
    end

    it do
      is_expected.to contain_yumrepo('katello')
        .with_descr('katello nightly')
        .with_baseurl("https://yum.theforeman.org/katello/nightly/katello/el8/\$basearch/")
        .with_gpgkey('absent')
        .with_gpgcheck(false)
        .with_enabled(true)
    end

    it { is_expected.to contain_anchor('katello::repo').that_requires('Yumrepo[katello]') }
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
        .with_baseurl("https://yum.theforeman.org/katello/3.14/katello/el8/\$basearch/")
        .with_gpgkey('https://yum.theforeman.org/releases/1.24/RPM-GPG-KEY-foreman')
        .with_gpgcheck(true)
        .with_enabled(true)
    end
  end
  context 'with manage_repo => true on EL8 with modular metadata' do
    let :params do
      {
        'repo_version' => 'nightly',
        'gpgcheck'     => false,
      }
    end

    it do
      is_expected.to contain_yumrepo('katello')
        .with_descr('katello nightly')
        .with_baseurl("https://yum.theforeman.org/katello/nightly/katello/el8/\$basearch/")
        .with_gpgcheck(false)
        .with_enabled(true)

      is_expected.to contain_package('katello-dnf-module')
        .with_ensure('el8')
        .with_provider('dnfmodule')
    end
  end
end

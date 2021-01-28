require 'spec_helper'

describe 'katello::qpid_client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('certs::qpid') }

      it do
        is_expected.to create_class('qpid::client')
          .with_ssl(true)
          .with_ssl_cert_name('broker')
          .with_ssl_cert_db('/etc/pki/katello/nssdb')
          .with_ssl_cert_password_file('/etc/pki/katello/nssdb/nss_db_password-file')
          .that_requires('Class[Certs::Qpid]')
      end
    end
  end
end

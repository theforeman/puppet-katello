# Install and configure a qpid client.
# This is used by the Katello rails app to connect to the
# qpid message broker.
class katello::qpid_client {
  include ::certs
  include ::certs::qpid

  class { '::qpid::client':
    ssl                    => true,
    ssl_cert_name          => 'broker',
    ssl_cert_db            => $::certs::nss_db_dir,
    ssl_cert_password_file => $::certs::qpid::nss_db_password_file,
    require                => Class['certs', 'certs::qpid'],
  }

  contain ::qpid::client
}

# @summary Katello qpid Config
#
# @param interface
#   The interface to listen on
#
# @param wcache_page_size
#   The size (in KB) of the pages in the write page cache
#
class katello::qpid (
  String $interface = 'lo',
  Integer[0, 5000] $wcache_page_size = 4,
) {
  include katello::params

  $agent_event_queue_name = $katello::params::agent_event_queue_name

  if $katello::params::enable_katello_agent {
    include certs
    include certs::qpid

    $_qpid_ensure = 'present'
    $ssl = true
    $ssl_cert_db = $certs::qpid::nss_db_dir
    $ssl_cert_password_file = $certs::qpid::nss_db_password_file
    $ssl_cert_name = $certs::qpid::nss_cert_name

    Class['certs', 'certs::qpid'] ~> Class['qpid']
  } else {
    $_qpid_ensure = 'absent'
    $ssl = false
    $ssl_cert_db = undef
    $ssl_cert_password_file = undef
    $ssl_cert_name = undef
  }

  class { 'qpid':
    ensure                 => $_qpid_ensure,
    ssl                    => $ssl,
    ssl_cert_db            => $ssl_cert_db,
    ssl_cert_password_file => $ssl_cert_password_file,
    ssl_cert_name          => $ssl_cert_name,
    acl_content            => template('katello/qpid_acls.acl'),
    interface              => $interface,
    wcache_page_size       => $wcache_page_size,
    auth                   => true,
  }

  contain qpid

  if $katello::params::enable_katello_agent {
    qpid::config::queue { $katello::params::agent_event_queue_name:
      ssl_cert       => $certs::qpid::client_cert,
      ssl_key        => $certs::qpid::client_key,
      hostname       => $katello::params::qpid_hostname,
      username       => $certs::qpid::hostname,
      sasl_mechanism => 'EXTERNAL',
    }
  }
}

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
  include certs
  include certs::qpid
  include katello::params

  class { 'qpid':
    ssl                    => true,
    ssl_cert_db            => $certs::qpid::nss_db_dir,
    ssl_cert_password_file => $certs::qpid::nss_db_password_file,
    ssl_cert_name          => 'broker',
    acl_content            => file('katello/qpid_acls.acl'),
    interface              => $interface,
    wcache_page_size       => $wcache_page_size,
    subscribe              => Class['certs', 'certs::qpid'],
  }

  contain qpid

  qpid::config::queue { $katello::params::candlepin_event_queue:
    ssl_cert => $certs::qpid::client_cert,
    ssl_key  => $certs::qpid::client_key,
    hostname => $katello::params::qpid_hostname,
  }

  qpid::config::bind { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created', 'system_purpose_compliance.created']:
    queue    => $katello::params::candlepin_event_queue,
    exchange => $katello::params::candlepin_qpid_exchange,
    ssl_cert => $certs::qpid::client_cert,
    ssl_key  => $certs::qpid::client_key,
    hostname => $katello::params::qpid_hostname,
  } ->
  # This anchor indicates the event queue is all set up.
  anchor { 'katello::qpid::event_queue': }
}

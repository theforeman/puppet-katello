# Katello qpid Config
class katello::qpid (
  String $katello_user = $::katello::user,
  String $candlepin_event_queue = $::katello::candlepin_event_queue,
  String $candlepin_qpid_exchange = $::katello::candlepin_qpid_exchange,
  Integer[0, 5000] $wcache_page_size = $::katello::qpid_wcache_page_size,
  String $interface = 'lo',
) {
  include ::certs
  include ::certs::qpid

  class { '::qpid':
    ssl                    => true,
    ssl_cert_db            => $::certs::nss_db_dir,
    ssl_cert_password_file => $::certs::qpid::nss_db_password_file,
    ssl_cert_name          => 'broker',
    interface              => $interface,
    wcache_page_size       => $wcache_page_size,
    subscribe              => Class['certs', 'certs::qpid'],
  }

  contain ::qpid

  User<|title == $katello_user|>{groups +> 'qpidd'}

  qpid::config_cmd { 'delete katello entitlements queue if bound to *.*':
    command  => "del queue ${candlepin_event_queue} --force",
    onlyif   => "list binding | grep ${candlepin_event_queue} | grep '*.*'",
    ssl_cert => $::certs::qpid::client_cert,
    ssl_key  => $::certs::qpid::client_key,
  } ->
  qpid::config::queue { $candlepin_event_queue:
    ssl_cert => $::certs::qpid::client_cert,
    ssl_key  => $::certs::qpid::client_key,
  }

  qpid::config::bind { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created']:
    queue    => $candlepin_event_queue,
    exchange => $candlepin_qpid_exchange,
    ssl_cert => $::certs::qpid::client_cert,
    ssl_key  => $::certs::qpid::client_key,
  }
}

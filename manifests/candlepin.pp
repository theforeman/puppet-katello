# @summary Install and configure candlepin
#
# @param db_host
#   The database host
# @param db_port
#   The database port
# @param db_name
#   The database name
# @param db_user
#   The database username
# @param db_password
#   The database password. A random password will be generated when
#   unspecified.
# @param db_ssl
#   Whether to connect using SSL
# @param db_ssl_verify
#   Whether to verify the certificate of the database host
# @param manage_db
#   Whether to manage the database. Set this to false when using a remote database
class katello::candlepin (
  Stdlib::Host $db_host = 'localhost',
  Optional[Stdlib::Port] $db_port = undef,
  String $db_name = 'candlepin',
  String $db_user = 'candlepin',
  Optional[String] $db_password = undef,
  Boolean $db_ssl = false,
  Boolean $db_ssl_verify = true,
  Boolean $manage_db = true,
) {
  include certs
  include katello::params

  class { 'certs::candlepin':
    hostname => $katello::params::candlepin_host,
  }

  Anchor <| title == 'katello::qpid::event_queue' |> ->
  class { 'candlepin':
    host                         => $katello::params::candlepin_host,
    user_groups                  => $certs::candlepin::group,
    oauth_key                    => $katello::params::candlepin_oauth_key,
    oauth_secret                 => $katello::params::candlepin_oauth_secret,
    ca_key                       => $certs::candlepin::ca_key,
    ca_cert                      => $certs::candlepin::ca_cert,
    keystore_file                => $certs::candlepin::keystore,
    keystore_password            => $certs::candlepin::keystore_password,
    truststore_password          => $certs::candlepin::keystore_password,
    enable_basic_auth            => false,
    consumer_system_name_pattern => '.+',
    adapter_module               => 'org.candlepin.katello.KatelloModule',
    amq_enable                   => true,
    amqp_keystore_password       => $certs::candlepin::keystore_password,
    amqp_truststore_password     => $certs::candlepin::keystore_password,
    amqp_keystore                => $certs::candlepin::amqp_keystore,
    amqp_truststore              => $certs::candlepin::amqp_truststore,
    qpid_hostname                => $katello::params::qpid_hostname,
    qpid_ssl_cert                => $certs::candlepin::client_cert,
    qpid_ssl_key                 => $certs::candlepin::client_key,
    db_host                      => $db_host,
    db_port                      => $db_port,
    db_name                      => $db_name,
    db_user                      => $db_user,
    db_password                  => $db_password,
    db_ssl                       => $db_ssl,
    db_ssl_verify                => $db_ssl_verify,
    manage_db                    => $manage_db,
    subscribe                    => Class['certs', 'certs::candlepin'],
  } ->
  anchor { 'katello::candlepin': }

  contain candlepin
}

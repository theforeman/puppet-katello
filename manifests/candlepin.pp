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
  Stdlib::Absolutepath $ca_cert = '/etc/foreman-pki/certs/candlepin/ca.crt',
  Stdlib::Absolutepath $ca_key = '/etc/foreman-pki/certs/candlepin/ca.key',
  Stdlib::Absolutepath $keystore_file = '/etc/foreman-pki/certs/tomcat/keystore',
  Stdlib::Absolutepath $keystore_password_file = '/etc/foreman-pki/certs/tomcat/password',
  Stdlib::Absolutepath $truststore_file = '/etc/foreman-pki/certs/artemis/truststore',
  Stdlib::Absolutepath $truststore_password_file = '/etc/foreman-pki/certs/artemis/password',
) {
  include katello::params

  class { 'candlepin':
    host                         => $katello::params::candlepin_host,
    oauth_key                    => $katello::params::candlepin_oauth_key,
    oauth_secret                 => $katello::params::candlepin_oauth_secret,
    ca_key                       => $ca_key,
    ca_cert                      => $ca_cert,
    keystore_file                => $keystore_file,
    keystore_password            => file($keystore_password_file),
    truststore_file              => $truststore_file,
    truststore_password          => file($truststore_password_file),
    artemis_client_dn            => "CN=${katello::params::candlepin_host}",
    enable_basic_auth            => false,
    consumer_system_name_pattern => '.+',
    adapter_module               => 'org.candlepin.katello.KatelloModule',
    db_host                      => $db_host,
    db_port                      => $db_port,
    db_name                      => $db_name,
    db_user                      => $db_user,
    db_password                  => $db_password,
    db_ssl                       => $db_ssl,
    db_ssl_verify                => $db_ssl_verify,
    manage_db                    => $manage_db,
  } ->
  anchor { 'katello::candlepin': } # lint:ignore:anchor_resource

  contain candlepin
}

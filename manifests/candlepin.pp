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
# @param db_ssl_ca
#   The CA certificate to verify the SSL connection to the database with
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
  Optional[Stdlib::Absolutepath] $db_ssl_ca = undef,
  Boolean $manage_db = true,
) {
  include certs
  include katello::params

  class { 'certs::candlepin':
    hostname             => $katello::params::candlepin_host,
    client_keypair_group => $katello::params::candlepin_client_keypair_group,
  }

  class { 'candlepin':
    host                         => $katello::params::candlepin_host,
    ssl_port                     => $katello::params::candlepin_port,
    user_groups                  => $certs::candlepin::group,
    oauth_key                    => $katello::params::candlepin_oauth_key,
    oauth_secret                 => $katello::params::candlepin_oauth_secret,
    ca_key                       => $certs::candlepin::ca_key,
    ca_cert                      => $certs::candlepin::ca_cert,
    keystore_file                => $certs::candlepin::keystore,
    keystore_password            => $certs::candlepin::keystore_password,
    truststore_file              => $certs::candlepin::truststore,
    truststore_password          => $certs::candlepin::truststore_password,
    artemis_client_certificate   => $certs::candlepin::client_cert,
    java_home                    => '/usr/lib/jvm/jre-11',
    java_package                 => 'java-11-openjdk',
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
    db_ssl_ca                    => $db_ssl_ca,
    manage_db                    => $manage_db,
    subscribe                    => Class['certs', 'certs::candlepin'],
  } ->
  anchor { 'katello::candlepin': } # lint:ignore:anchor_resource

  contain candlepin
}

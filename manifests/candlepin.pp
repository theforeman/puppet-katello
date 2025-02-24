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
# @param artemis_client_dn
#   The Distinguished Name of the client certificate that's allowed to access
#   Artemis. It should still be signed by the correct Certificate Authority.
# @param loggers
#   Configure the Candlepin loggers
# @param facts_match_regex
#   Configure the Candlepin facts_match_regex
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
  Variant[Undef, Deferred, String[1]] $artemis_client_dn = undef,
  Hash[String[1], Candlepin::LogLevel] $loggers = {},
  Optional[String[1]] $facts_match_regex = undef,
) {
  include certs
  include katello::params

  class { 'certs::candlepin':
    hostname             => $katello::params::candlepin_host,
    client_keypair_group => $katello::params::candlepin_client_keypair_group,
    deploy               => false,
  }
}

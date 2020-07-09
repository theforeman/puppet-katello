# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $enable_yum::         Enable rpm content plugin, including syncing of yum content
#
# $enable_file::        Enable generic file content management
#
# $enable_container::   Enable container content plugin
#
# === Advanced parameters:
#
# $candlepin_oauth_key:: The OAuth key for talking to the candlepin API
#
# $candlepin_oauth_secret:: The OAuth secret for talking to the candlepin API
#
# $num_pulp_workers::   Number of pulp workers to use
#
# $candlepin_db_host::  Host with Candlepin DB
#
# $candlepin_db_port::  Port accepting connections to Candlepin DB
#
# $candlepin_db_name::  Name of the Candlepin DB
#
# $candlepin_db_user::  Candlepin DB user
#
# $candlepin_db_password:: Candlepin DB password
#
# $candlepin_db_ssl::   Boolean indicating if the connection to the database should be over
#                       an SSL connection. Requires DB host's CA Cert in the system trust
#
# $candlepin_db_ssl_verify:: Boolean indicating if the SSL connection to the database should be verified
#
# $candlepin_manage_db:: Boolean indicating whether a database should be installed, this includes db creation and user
#
# $rest_client_timeout:: Timeout for Katello rest API
#
# $use_pulp_2_for_file::   Configures Katello to use Pulp 2 for file content
#
# $use_pulp_2_for_docker:: Configures Katello to use Pulp 2 for docker content
#
# $use_pulp_2_for_yum::    Configures Katello to use Pulp 2 for yum content
#
class katello (
  Optional[String] $candlepin_oauth_key = undef,
  Optional[String] $candlepin_oauth_secret = undef,

  Integer[0] $rest_client_timeout = 3600,
  Optional[Integer[1]] $num_pulp_workers = undef,

  Boolean $enable_yum = true,
  Boolean $enable_file = true,
  Boolean $enable_container = true,

  Boolean $use_pulp_2_for_file = false,
  Boolean $use_pulp_2_for_docker = false,
  Boolean $use_pulp_2_for_yum = false,

  String $candlepin_db_host = 'localhost',
  Optional[Stdlib::Port] $candlepin_db_port = undef,
  String $candlepin_db_name = 'candlepin',
  String $candlepin_db_user = 'candlepin',
  Optional[String] $candlepin_db_password = undef,
  Boolean $candlepin_db_ssl = false,
  Boolean $candlepin_db_ssl_verify = true,
  Boolean $candlepin_manage_db = true,
) {

  package { 'katello':
    ensure => installed,
  }

  class { 'katello::globals':
    enable_yum    => $enable_yum,
    enable_file   => $enable_file,
    enable_container => $enable_container,
  }

  class { 'katello::params':
    candlepin_oauth_key    => $candlepin_oauth_key,
    candlepin_oauth_secret => $candlepin_oauth_secret,
  }

  class { 'certs::candlepin':
    hostname => $katello::params::candlepin_host,
  } ->
  class { 'katello::candlepin':
    db_host             => $candlepin_db_host,
    db_port             => $candlepin_db_port,
    db_name             => $candlepin_db_name,
    db_user             => $candlepin_db_user,
    db_password         => $candlepin_db_password,
    db_ssl              => $candlepin_db_ssl,
    db_ssl_verify       => $candlepin_db_ssl_verify,
    manage_db           => $candlepin_manage_db,
    ca_key              => $certs::candlepin::ca_key,
    ca_cert             => $certs::candlepin::ca_cert,
    keystore_file       => $certs::candlepin::keystore,
    keystore_password   => $certs::candlepin::keystore_password,
    truststore_password => $certs::candlepin::keystore_password,
    artemis_client_dn   => $certs::candlepin::artemis_client_dn,
  }

  include certs
  include certs::apache
  include certs::foreman
  include certs::pulp_client

  Class['certs', 'certs::ca', 'certs::apache'] ~> Class['apache::service']

  class { 'katello::application':
    rest_client_timeout       => $rest_client_timeout,
    use_pulp_2_for_file       => $use_pulp_2_for_file,
    use_pulp_2_for_docker     => $use_pulp_2_for_docker,
    use_pulp_2_for_yum        => $use_pulp_2_for_yum,
    pulp_client_cert          => $certs::pulp_client::client_cert,
    pulp_client_key           => $certs::pulp_client::client_key,
    pulp_ca_cert              => $certs::katello_server_ca_cert, # TODO: certs::apache::...
    candlepin_ca_cert         => $certs::ca_cert,
    candlepin_events_ssl_cert => $certs::candlepin::client_cert,
    candlepin_events_ssl_key  => $certs::candlepin::client_key,
  }
}

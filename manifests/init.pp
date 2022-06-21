# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# === Advanced parameters:
#
# $candlepin_oauth_key:: The OAuth key for talking to the candlepin API
#
# $candlepin_oauth_secret:: The OAuth secret for talking to the candlepin API
#
# $qpid_wcache_page_size:: The size (in KB) of the pages in the write page cache
#
# $qpid_interface::     The interface qpidd listens to.
#
# $qpid_hostname::      Hostname used to connect to qpidd.
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
# $candlepin_db_ssl_ca:: The CA certificate to verify the SSL connection to the database with
#
# $candlepin_manage_db:: Boolean indicating whether a database should be installed, this includes db creation and user
#
# $rest_client_timeout:: Timeout for Katello rest API
#
# $hosts_queue_workers::   Configures the number of workers handling the hosts_queue queue.
#
class katello (
  Optional[String] $candlepin_oauth_key = undef,
  Optional[String] $candlepin_oauth_secret = undef,

  Integer[0] $rest_client_timeout = 3600,
  Integer[0, 1000] $qpid_wcache_page_size = 4,
  String $qpid_interface = 'lo',
  Stdlib::Host $qpid_hostname = 'localhost',

  String $candlepin_db_host = 'localhost',
  Optional[Stdlib::Port] $candlepin_db_port = undef,
  String $candlepin_db_name = 'candlepin',
  String $candlepin_db_user = 'candlepin',
  Optional[String] $candlepin_db_password = undef,
  Boolean $candlepin_db_ssl = false,
  Boolean $candlepin_db_ssl_verify = true,
  Optional[Stdlib::Absolutepath] $candlepin_db_ssl_ca = undef,
  Boolean $candlepin_manage_db = true,

  Integer[0] $hosts_queue_workers = 1,
) {
  package { 'katello':
    ensure => installed,
  }

  class { 'katello::params':
    candlepin_oauth_key    => $candlepin_oauth_key,
    candlepin_oauth_secret => $candlepin_oauth_secret,
    qpid_hostname          => $qpid_hostname,
  }

  class { 'katello::candlepin':
    db_host       => $candlepin_db_host,
    db_port       => $candlepin_db_port,
    db_name       => $candlepin_db_name,
    db_user       => $candlepin_db_user,
    db_password   => $candlepin_db_password,
    db_ssl        => $candlepin_db_ssl,
    db_ssl_verify => $candlepin_db_ssl_verify,
    db_ssl_ca     => $candlepin_db_ssl_ca,
    manage_db     => $candlepin_manage_db,
  }

  class { 'katello::application':
    rest_client_timeout => $rest_client_timeout,
    hosts_queue_workers => $hosts_queue_workers,
  }

  class { 'katello::qpid':
    interface        => $qpid_interface,
    wcache_page_size => $qpid_wcache_page_size,
  }
}

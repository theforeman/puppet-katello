# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $enable_ostree::      Enable ostree content plugin, this requires an ostree install
#
# $enable_yum::         Enable rpm content plugin, including syncing of yum content
#
# $enable_file::        Enable generic file content management
#
# $enable_puppet::      Enable puppet content plugin
#
# $enable_docker::      Enable docker content plugin
#
# $enable_deb::         Enable debian content plugin
#
# $proxy_url::          URL of the proxy server
#
# $proxy_port::         Port the proxy is running on
#
# $proxy_username::     Proxy username for authentication
#
# $proxy_password::     Proxy password for authentication
#
# $pulp_max_speed::     The maximum download speed per second for a Pulp task, such as a sync. (e.g. "4 Kb" (Uses SI KB), 4MB, or 1GB" )
#
# $repo_export_dir::    Directory to create for repository exports
#
# === Advanced parameters:
#
# $candlepin_oauth_key:: The OAuth key for talking to the candlepin API
#
# $candlepin_oauth_secret:: The OAuth secret for talking to the candlepin API
#
# $cdn_ssl_version::    SSL version used to communicate with the CDN
#
# $num_pulp_workers::   Number of pulp workers to use
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
# $candlepin_manage_db:: Boolean indicating whether a database should be installed, this includes db creation and user
#
# $rest_client_timeout:: Timeout for Katello rest API
#
# $pulp_worker_timeout:: The amount of time (in seconds) before considering a worker as missing. If Pulp's
#                        mongo database has slow I/O, then setting a higher number may resolve issues where workers are
#                        going missing incorrectly.
#
# $pulp_db_name::        Name of the database to use
#
# $pulp_db_seeds::       Comma-separated list of hostname:port of database replica seed hosts
#
# $pulp_db_username::    The user name to use for authenticating to the MongoDB server
#
# $pulp_db_password::    The password to use for authenticating to the MongoDB server
#
# $pulp_db_replica_set:: The name of replica set configured in MongoDB, if one is in use
#
# $pulp_db_ssl::         Whether to connect to the database server using SSL.
#
# $pulp_db_ssl_keyfile:: A path to the private keyfile used to identify the local connection against mongod. If
#                        included with the certfile then only the ssl_certfile is needed.
#
# $pulp_db_ssl_certfile:: The certificate file used to identify the local connection against mongod.
#
# $pulp_db_verify_ssl::  Specifies whether a certificate is required from the other side of the connection, and
#                        whether it will be validated if provided. If it is true, then the ca_certs parameter
#                        must point to a file of CA certificates used to validate the connection.
#
# $pulp_db_ca_path::     The ca_certs file contains a set of concatenated "certification authority" certificates,
#                        which are used to validate certificates passed from the other end of the connection.
#
# $pulp_db_unsafe_autoretry:: If true, retry commands to the database if there is a connection error.
#                             Warning: if set to true, this setting can result in duplicate records.
#
# $pulp_db_write_concern:: Write concern of 'majority' or 'all'. When 'all' is specified, 'w' is set to number of
#                          seeds specified. For version of MongoDB < 2.6, replica_set must also be specified.
#                          Please note that 'all' will cause Pulp to halt if any of the replica set members is not
#                          available. 'majority' is used by default
#
# $pulp_manage_db::      Boolean to install and configure the mongodb.
#
class katello (
  Optional[String] $candlepin_oauth_key = undef,
  Optional[String] $candlepin_oauth_secret = undef,

  Integer[0] $rest_client_timeout = 3600,
  Integer[0, 1000] $qpid_wcache_page_size = 4,
  String $qpid_interface = 'lo',
  Stdlib::Host $qpid_hostname = 'localhost',
  Optional[Integer[1]] $num_pulp_workers = undef,
  Integer[0] $pulp_worker_timeout = 60,
  Optional[Stdlib::HTTPUrl] $proxy_url = undef,
  Optional[Stdlib::Port] $proxy_port = undef,
  Optional[String] $proxy_username = undef,
  Optional[String] $proxy_password = undef,
  Optional[String] $pulp_max_speed = undef,
  Optional[Enum['SSLv23', 'TLSv1']] $cdn_ssl_version = undef,

  Boolean $enable_ostree = false,
  Boolean $enable_yum = true,
  Boolean $enable_file = true,
  Boolean $enable_puppet = true,
  Boolean $enable_docker = true,
  Boolean $enable_deb = true,

  Stdlib::Absolutepath $repo_export_dir = '/var/lib/pulp/katello-export',

  String $candlepin_db_host = 'localhost',
  Optional[Stdlib::Port] $candlepin_db_port = undef,
  String $candlepin_db_name = 'candlepin',
  String $candlepin_db_user = 'candlepin',
  Optional[String] $candlepin_db_password = undef,
  Boolean $candlepin_db_ssl = false,
  Boolean $candlepin_db_ssl_verify = true,
  Boolean $candlepin_manage_db = true,

  String $pulp_db_name = 'pulp_database',
  String $pulp_db_seeds = 'localhost:27017',
  Optional[String] $pulp_db_username = undef,
  Optional[String] $pulp_db_password = undef,
  Optional[String] $pulp_db_replica_set = undef,
  Boolean $pulp_db_ssl = false,
  Optional[Stdlib::Absolutepath] $pulp_db_ssl_keyfile = undef,
  Optional[Stdlib::Absolutepath] $pulp_db_ssl_certfile = undef,
  Boolean $pulp_db_verify_ssl = true,
  Stdlib::Absolutepath $pulp_db_ca_path = '/etc/pki/tls/certs/ca-bundle.crt',
  Boolean $pulp_db_unsafe_autoretry = false,
  Optional[Enum['majority', 'all']] $pulp_db_write_concern = undef,
  Boolean $pulp_manage_db = true,
) {

  package { 'katello':
    ensure => installed,
  }

  class { 'katello::globals':
    enable_ostree => $enable_ostree,
    enable_yum    => $enable_yum,
    enable_file   => $enable_file,
    enable_puppet => $enable_puppet,
    enable_docker => $enable_docker,
    enable_deb    => $enable_deb,
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
    manage_db     => $candlepin_manage_db,
  }

  class { 'katello::qpid':
    interface        => $qpid_interface,
    wcache_page_size => $qpid_wcache_page_size,
  }

  class { 'katello::pulp':
    yum_max_speed            => $pulp_max_speed,
    num_workers              => $num_pulp_workers,
    worker_timeout           => $pulp_worker_timeout,
    mongodb_name             => $pulp_db_name,
    mongodb_seeds            => $pulp_db_seeds,
    mongodb_username         => $pulp_db_username,
    mongodb_password         => $pulp_db_password,
    mongodb_replica_set      => $pulp_db_replica_set,
    mongodb_ssl              => $pulp_db_ssl,
    mongodb_ssl_keyfile      => $pulp_db_ssl_keyfile,
    mongodb_ssl_certfile     => $pulp_db_ssl_certfile,
    mongodb_verify_ssl       => $pulp_db_verify_ssl,
    mongodb_ca_path          => $pulp_db_ca_path,
    mongodb_unsafe_autoretry => $pulp_db_unsafe_autoretry,
    mongodb_write_concern    => $pulp_db_write_concern,
    manage_mongodb           => $pulp_manage_db,
    repo_export_dir          => $repo_export_dir,
  }

  class { 'katello::application':
    rest_client_timeout => $rest_client_timeout,
    cdn_ssl_version     => $cdn_ssl_version,
    proxy_host          => $proxy_url,
    proxy_port          => $proxy_port,
    proxy_username      => $proxy_username,
    proxy_password      => $proxy_password,
  }

}

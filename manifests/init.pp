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
# $user::               The Katello system user name
#
# $group::              The Katello system user group
#
# $user_groups::        Extra user groups the Katello user is a part of
#
# $candlepin_oauth_key:: The OAuth key for talking to the candlepin API
#
# $candlepin_oauth_secret:: The OAuth secret for talking to the candlepin API
#
# $post_sync_token::    The shared secret for pulp notifying katello about
#                       completed syncs
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
# $package_names::      Packages that this module ensures are present instead of the default
#
# $manage_repo::        Whether to manage the yum repository
#
# $repo_version::       Which yum repository to install. For example
#                       latest or 3.3.
#
# $repo_gpgcheck::      Whether to check the GPG signatures
#
# $repo_gpgkey::        The GPG key to use
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
  String $user = $katello::params::user,
  String $group = $katello::params::group,
  Variant[Array[String], String] $user_groups = $katello::params::user_groups,

  String $candlepin_oauth_key = $katello::params::candlepin_oauth_key,
  String $candlepin_oauth_secret = $katello::params::candlepin_oauth_secret,

  String $post_sync_token = $katello::params::post_sync_token,
  Integer[0] $rest_client_timeout = $katello::params::rest_client_timeout,
  Integer[0, 1000] $qpid_wcache_page_size = $katello::params::qpid_wcache_page_size,
  String $qpid_interface = $katello::params::qpid_interface,
  String $qpid_hostname = $katello::params::qpid_hostname,
  Integer[1] $num_pulp_workers = $katello::params::num_pulp_workers,
  Integer[0] $pulp_worker_timeout = $katello::params::pulp_worker_timeout,
  Optional[Stdlib::HTTPUrl] $proxy_url = $katello::params::proxy_url,
  Optional[Integer[0, 65535]] $proxy_port = $katello::params::proxy_port,
  Optional[String] $proxy_username = $katello::params::proxy_username,
  Optional[String] $proxy_password = $katello::params::proxy_password,
  Optional[String] $pulp_max_speed = $katello::params::pulp_max_speed,
  Optional[Enum['SSLv23', 'TLSv1']] $cdn_ssl_version = $katello::params::cdn_ssl_version,

  Array[String] $package_names = $katello::params::package_names,
  Boolean $enable_ostree = $katello::params::enable_ostree,
  Boolean $enable_yum = $katello::params::enable_yum,
  Boolean $enable_file = $katello::params::enable_file,
  Boolean $enable_puppet = $katello::params::enable_puppet,
  Boolean $enable_docker = $katello::params::enable_docker,
  Boolean $enable_deb = $katello::params::enable_deb,


  Stdlib::Absolutepath $repo_export_dir = $katello::params::repo_export_dir,

  Boolean $manage_repo = $katello::params::manage_repo,
  String $repo_version = $katello::params::repo_version,
  Boolean $repo_gpgcheck = $katello::params::repo_gpgcheck,
  Optional[String] $repo_gpgkey = $katello::params::repo_gpgkey,

  String $candlepin_db_host = $katello::params::candlepin_db_host,
  Optional[Integer[0, 65535]] $candlepin_db_port = $katello::params::candlepin_db_port,
  String $candlepin_db_name = $katello::params::candlepin_db_name,
  String $candlepin_db_user = $katello::params::candlepin_db_user,
  String $candlepin_db_password = $katello::params::candlepin_db_password,
  Boolean $candlepin_db_ssl = $katello::params::candlepin_db_ssl,
  Boolean $candlepin_db_ssl_verify = $katello::params::candlepin_db_ssl_verify,
  Boolean $candlepin_manage_db = $katello::params::candlepin_manage_db,

  String $pulp_db_name = $katello::params::pulp_db_name,
  String $pulp_db_seeds = $katello::params::pulp_db_seeds,
  Optional[String] $pulp_db_username = $katello::params::pulp_db_username,
  Optional[String] $pulp_db_password = $katello::params::pulp_db_password,
  Optional[String] $pulp_db_replica_set = $katello::params::pulp_db_replica_set,
  Boolean $pulp_db_ssl = $katello::params::pulp_db_ssl,
  Optional[Stdlib::Absolutepath] $pulp_db_ssl_keyfile = $katello::params::pulp_db_ssl_keyfile,
  Optional[Stdlib::Absolutepath] $pulp_db_ssl_certfile = $katello::params::pulp_db_ssl_certfile,
  Boolean $pulp_db_verify_ssl = $katello::params::pulp_db_verify_ssl,
  Stdlib::Absolutepath $pulp_db_ca_path = $katello::params::pulp_db_ca_path,
  Boolean $pulp_db_unsafe_autoretry = $katello::params::pulp_db_unsafe_autoretry,
  Optional[Enum['majority', 'all']] $pulp_db_write_concern = $katello::params::pulp_db_write_concern,
  Boolean $pulp_manage_db = $katello::params::pulp_manage_db,
) inherits katello::params {

  include katello::repo
  include katello::candlepin
  include katello::qpid
  include katello::pulp
  Class['katello::repo'] -> Class['katello::pulp']
  include katello::application
  Class['katello::repo'] -> Class['katello::application']
  Class['katello::qpid'] -> Class['katello::candlepin'] -> Class['katello::application']

}

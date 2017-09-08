# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $enable_ostree::      Enable ostree plugin, this requires an ostree install
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
# $pulp_oauth_key::     The OAuth key for talking to the Pulp API
#
# $pulp_oauth_secret::  The OAuth secret for talking to the Pulp API
#
# $post_sync_token::    The shared secret for pulp notifying katello about
#                       completed syncs
#
# $cdn_ssl_version::    SSL version used to communicate with the CDN
#
# $num_pulp_workers::   Number of pulp workers to use
#
# $max_tasks_per_pulp_worker:: Number of tasks after which the worker gets restarted
#
# $qpid_wcache_page_size:: The size (in KB) of the pages in the write page cache
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
class katello (
  String $user = $::katello::params::user,
  String $group = $::katello::params::group,
  Variant[Array[String], String] $user_groups = $::katello::params::user_groups,

  String $candlepin_oauth_key = $::katello::params::candlepin_oauth_key,
  String $candlepin_oauth_secret = $::katello::params::candlepin_oauth_secret,
  String $pulp_oauth_key = $::katello::params::pulp_oauth_key,
  String $pulp_oauth_secret = $::katello::params::pulp_oauth_secret,

  String $post_sync_token = $::katello::params::post_sync_token,
  Integer[0, 1000] $qpid_wcache_page_size = $::katello::params::qpid_wcache_page_size,
  Integer[1] $num_pulp_workers = $::katello::params::num_pulp_workers,
  Optional[Integer] $max_tasks_per_pulp_worker = $::katello::params::max_tasks_per_pulp_worker,
  Optional[Stdlib::HTTPUrl] $proxy_url = $::katello::params::proxy_url,
  Optional[Integer[0, 65535]] $proxy_port = $::katello::params::proxy_port,
  Optional[String] $proxy_username = $::katello::params::proxy_username,
  Optional[String] $proxy_password = $::katello::params::proxy_password,
  Optional[String] $pulp_max_speed = $::katello::params::pulp_max_speed,
  Optional[Enum['SSLv23', 'TLSv1']] $cdn_ssl_version = $::katello::params::cdn_ssl_version,

  Array[String] $package_names = $::katello::params::package_names,
  Boolean $enable_ostree = $::katello::params::enable_ostree,

  Stdlib::Absolutepath $repo_export_dir = $::katello::params::repo_export_dir,

  Boolean $manage_repo = $::katello::params::manage_repo,
  String $repo_version = $::katello::params::repo_version,
  Boolean $repo_gpgcheck = $::katello::params::repo_gpgcheck,
  Optional[String] $repo_gpgkey = $::katello::params::repo_gpgkey,

  String $candlepin_db_host = $::katello::params::candlepin_db_host,
  Optional[Integer[0, 65535]] $candlepin_db_port = $::katello::params::candlepin_db_port,
  String $candlepin_db_name = $::katello::params::candlepin_db_name,
  String $candlepin_db_user = $::katello::params::candlepin_db_user,
  String $candlepin_db_password = $::katello::params::candlepin_db_password,
  Boolean $candlepin_db_ssl = $::katello::params::candlepin_db_ssl,
  Boolean $candlepin_db_ssl_verify = $::katello::params::candlepin_db_ssl_verify,
  Boolean $candlepin_manage_db = $::katello::params::candlepin_manage_db,
) inherits katello::params {
  include ::katello::repo
  include ::katello::candlepin
  include ::katello::qpid
  include ::katello::pulp
  Class['katello::repo'] -> Class['katello::pulp']
  include ::katello::application
  Class['katello::repo'] -> Class['katello::application']
  Class['katello::candlepin'] -> Class['katello::application']

  User<|title == apache|>{groups +> $user_groups}
}

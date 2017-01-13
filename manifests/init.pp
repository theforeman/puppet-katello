# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $enable_ostree::      Enable ostree plugin, this requires an ostree install
#                       type:Boolean
#
# $proxy_url::          URL of the proxy server
#                       type:Stdlib::HTTPUrl
#
# $proxy_port::         Port the proxy is running on
#                       type:Integer[0, 65535]
#
# $proxy_username::     Proxy username for authentication
#                       type:String
#
# $proxy_password::     Proxy password for authentication
#                       type:String
#
# $repo_export_dir::    Directory to create for repository exports
#                       type:Stdlib::Absolutepath
#
# === Advanced parameters:
#
# $user::               The Katello system user name
#                       type:String
#
# $group::              The Katello system user group
#                       type:String
#
# $user_groups::        Extra user groups the Katello user is a part of
#                       type:Array[String]
#
# $oauth_key::          The OAuth key for talking to the candlepin API
#                       type:String
#
# $oauth_secret::       The OAuth secret for talking to the candlepin API
#                       type:String
#
# $post_sync_token::    The shared secret for pulp notifying katello about
#                       completed syncs
#                       type:String
#
# $log_dir::            Location for Katello log files to be placed
#                       type:Stdlib::Absolutepath
#
# $config_dir::         Location for Katello config files
#                       type:Stdlib::Absolutepath
#
# $cdn_ssl_version::    SSL version used to communicate with the CDN
#                       type:Optional[Enum['SSLv23', 'TLSv1']]
#
# $num_pulp_workers::   Number of pulp workers to use
#                       type:Integer[1]
#
# $package_names::      Packages that this module ensures are present instead of the default
#                       type:Array[String]
#
class katello (
  $user             = $katello::params::user,
  $group            = $katello::params::group,
  $user_groups      = $katello::params::user_groups,

  $oauth_key        = $katello::params::oauth_key,
  $oauth_secret     = $katello::params::oauth_secret,

  $post_sync_token  = $katello::params::post_sync_token,
  $num_pulp_workers = $katello::params::num_pulp_workers,
  $log_dir          = $katello::params::log_dir,
  $config_dir       = $katello::params::config_dir,

  $proxy_url        = $katello::params::proxy_url,
  $proxy_port       = $katello::params::proxy_port,
  $proxy_username   = $katello::params::proxy_username,
  $proxy_password   = $katello::params::proxy_password,
  $cdn_ssl_version  = $katello::params::cdn_ssl_version,

  $package_names    = $katello::params::package_names,
  $enable_ostree    = $katello::params::enable_ostree,

  $qpid_client_cert = undef,
  $qpid_client_key  = undef,

  $qpid_url         = $katello::params::qpid_url,
  $repo_export_dir  = $katello::params::repo_export_dir,
  ) inherits katello::params {
  validate_bool($enable_ostree)
  validate_absolute_path($repo_export_dir)

  class { '::katello::install': } ~>
  class { '::katello::config': } ~>
  class { '::katello::qpid':
    client_cert => $qpid_client_cert,
    client_key  => $qpid_client_key,
  }
}

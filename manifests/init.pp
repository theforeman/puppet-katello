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
# $oauth_key::          The OAuth key for talking to the candlepin API
#
# $oauth_secret::       The OAuth secret for talking to the candlepin API
#
# $post_sync_token::    The shared secret for pulp notifying katello about
#                       completed syncs
#
# $log_dir::            Location for Katello log files to be placed
#
# $config_dir::         Location for Katello config files
#
# $cdn_ssl_version::    SSL version used to communicate with the CDN
#
# $num_pulp_workers::   Number of pulp workers to use
#
# $max_tasks_per_pulp_worker:: Number of tasks after which the worker gets restarted
#
# $qpid_session_unacked:: Buffer if the broker has a large number of sessions and the memory overhead is a problem
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
class katello (
  String $user = $::katello::params::user,
  String $group = $::katello::params::group,
  Variant[Array[String], String] $user_groups = $::katello::params::user_groups,

  String $oauth_key = $::katello::params::oauth_key,
  String $oauth_secret = $::katello::params::oauth_secret,

  String $post_sync_token = $::katello::params::post_sync_token,
  Integer[0, 5000] $qpid_session_unacked = $::katello::params::qpid_session_unacked,
  Integer[0, 1000] $qpid_wcache_page_size = $::katello::params::qpid_wcache_page_size,
  Integer[1] $num_pulp_workers = $::katello::params::num_pulp_workers,
  Optional[Integer] $max_tasks_per_pulp_worker = $::katello::params::max_tasks_per_pulp_worker,
  Stdlib::Absolutepath $log_dir = $::katello::params::log_dir,
  Stdlib::Absolutepath $config_dir = $::katello::params::config_dir,
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
) inherits katello::params {
  $candlepin_ca_cert = $::certs::ca_cert
  $pulp_ca_cert = $::certs::katello_server_ca_cert

  Class['certs'] ~>
  class { '::certs::apache': } ~>
  class { '::katello::repo': } ~>
  class { '::katello::install': } ~>
  class { '::katello::config': } ~>
  class { '::certs::qpid': } ~>
  class { '::qpid':
    ssl                    => true,
    ssl_cert_db            => $::certs::nss_db_dir,
    ssl_cert_password_file => $::certs::qpid::nss_db_password_file,
    ssl_cert_name          => 'broker',
    interface              => 'lo',
    session_unacked        => $qpid_session_unacked,
    wcache_page_size       => $qpid_wcache_page_size,
  } ~>
  class { '::certs::candlepin': } ~>
  class { '::candlepin':
    user_groups                  => $katello::user_groups,
    oauth_key                    => $katello::oauth_key,
    oauth_secret                 => $katello::oauth_secret,
    deployment_url               => $katello::deployment_url,
    ca_key                       => $certs::ca_key,
    ca_cert                      => $certs::ca_cert_stripped,
    keystore_password            => $::certs::candlepin::keystore_password,
    truststore_password          => $::certs::candlepin::keystore_password,
    enable_basic_auth            => false,
    consumer_system_name_pattern => '.+',
    adapter_module               => 'org.candlepin.katello.KatelloModule',
    amq_enable                   => true,
    amqp_keystore_password       => $::certs::candlepin::keystore_password,
    amqp_truststore_password     => $::certs::candlepin::keystore_password,
    amqp_keystore                => $::certs::candlepin::amqp_keystore,
    amqp_truststore              => $::certs::candlepin::amqp_truststore,
    qpid_ssl_cert                => $::certs::qpid::client_cert,
    qpid_ssl_key                 => $::certs::qpid::client_key,
  } ~>
  class { '::certs::qpid_client': } ~>
  class { '::pulp':
    oauth_enabled          => true,
    oauth_key              => $katello::oauth_key,
    oauth_secret           => $katello::oauth_secret,
    messaging_url          => 'ssl://localhost:5671',
    messaging_ca_cert      => $::certs::ca_cert,
    messaging_client_cert  => $certs::qpid_client::messaging_client_cert,
    messaging_transport    => 'qpid',
    messaging_auth_enabled => false,
    broker_url             => 'qpid://localhost:5671',
    broker_use_ssl         => true,
    consumers_crl          => $candlepin::crl_file,
    proxy_url              => $proxy_url,
    proxy_port             => $proxy_port,
    proxy_username         => $proxy_username,
    proxy_password         => $proxy_password,
    yum_max_speed          => $pulp_max_speed,
    manage_broker          => false,
    manage_httpd           => false,
    manage_plugins_httpd   => true,
    manage_squid           => true,
    enable_rpm             => true,
    enable_puppet          => true,
    enable_docker          => true,
    enable_ostree          => $enable_ostree,
    num_workers            => $num_pulp_workers,
    max_tasks_per_child    => $max_tasks_per_pulp_worker,
    enable_parent_node     => false,
    repo_auth              => true,
    puppet_wsgi_processes  => 1,
    enable_katello         => true,
  } ~>
  class { '::qpid::client':
    ssl                    => true,
    ssl_cert_name          => 'broker',
    ssl_cert_db            => $certs::nss_db_dir,
    ssl_cert_password_file => $certs::qpid::nss_db_password_file,
  } ~>
  class { '::katello::qpid':
    client_cert => $certs::qpid::client_cert,
    client_key  => $certs::qpid::client_key,
  }

  class { '::certs::foreman': }

  Exec['cpinit'] -> Exec['foreman-rake-db:seed']
  Class['certs::candlepin'] ~> Service['tomcat']
  Class['certs::qpid'] ~> Service['qpidd']
  Class['certs::ca'] ~> Service['httpd']

  User<|title == apache|>{groups +> $user_groups}
}

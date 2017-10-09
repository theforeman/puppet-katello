# Katello configuration for pulp
class katello::pulp (
  String $oauth_key = $::katello::oauth_key,
  String $oauth_secret = $::katello::oauth_secret,
  Optional[String] $proxy_url = $::katello::proxy_url,
  Optional[Integer[0, 65535]] $proxy_port = $::katello::proxy_port,
  Optional[String] $proxy_username = $::katello::proxy_username,
  Optional[String] $proxy_password = $::katello::proxy_password,
  Optional[String] $yum_max_speed = $::katello::pulp_max_speed,
  Boolean $enable_ostree = $::katello::enable_ostree,
  Integer[1] $num_workers = $::katello::num_pulp_workers,
  Optional[Integer] $max_tasks_per_child = $::katello::max_tasks_per_pulp_worker,
  String $messaging_url = "ssl://${::katello::qpid_hostname}:5671",
  String $broker_url = "qpid://${::katello::qpid_hostname}:5671",
  Stdlib::Absolutepath $repo_export_dir = $::katello::repo_export_dir,
  String $repo_export_dir_owner = $::katello::user,
  String $repo_export_dir_group = $::katello::group,
) {
  include ::certs
  include ::certs::qpid_client

  class { '::pulp':
    oauth_enabled          => true,
    oauth_key              => $oauth_key,
    oauth_secret           => $oauth_secret,
    messaging_url          => $messaging_url,
    messaging_ca_cert      => $::certs::ca_cert,
    messaging_client_cert  => $::certs::qpid_client::messaging_client_cert,
    messaging_transport    => 'qpid',
    messaging_auth_enabled => false,
    broker_url             => $broker_url,
    broker_use_ssl         => true,
    proxy_url              => $proxy_url,
    proxy_port             => $proxy_port,
    proxy_username         => $proxy_username,
    proxy_password         => $proxy_password,
    yum_max_speed          => $yum_max_speed,
    manage_broker          => false,
    manage_httpd           => false,
    manage_plugins_httpd   => true,
    manage_squid           => true,
    enable_rpm             => true,
    enable_puppet          => true,
    enable_docker          => true,
    enable_ostree          => $enable_ostree,
    num_workers            => $num_workers,
    max_tasks_per_child    => $max_tasks_per_child,
    enable_parent_node     => false,
    repo_auth              => true,
    puppet_wsgi_processes  => 1,
    enable_katello         => true,
    subscribe              => Class['certs', 'certs::qpid_client'],
  }

  contain ::pulp

  foreman::config::passenger::fragment { 'pulp':
    content     => file('katello/pulp-apache.conf'),
    ssl_content => file('katello/pulp-apache-ssl.conf'),
  }

  # NB: we define this here to avoid a dependency cycle. It is not a problem if
  # this dir exists before the pulp RPMs are installed.
  file { '/var/lib/pulp':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  file { $repo_export_dir:
    ensure => directory,
    owner  => $repo_export_dir_owner,
    group  => $repo_export_dir_group,
    mode   => '0755',
  }
}

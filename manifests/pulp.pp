# Katello configuration for pulp
class katello::pulp (
  Optional[String] $proxy_url = $katello::proxy_url,
  Optional[Integer[0, 65535]] $proxy_port = $katello::proxy_port,
  Optional[String] $proxy_username = $katello::proxy_username,
  Optional[String] $proxy_password = $katello::proxy_password,
  Optional[String] $yum_max_speed = $katello::pulp_max_speed,
  Boolean $enable_ostree = $katello::enable_ostree,
  Boolean $enable_yum = $katello::enable_yum,
  Boolean $enable_file = $katello::enable_file,
  Boolean $enable_puppet = $katello::enable_puppet,
  Boolean $enable_docker = $katello::enable_docker,
  Boolean $enable_deb = $katello::enable_deb,
  Integer[1] $num_workers = $katello::num_pulp_workers,
  String $messaging_url = "ssl://${katello::qpid_hostname}:5671",
  String $broker_url = "qpid://${katello::qpid_hostname}:5671",
  Stdlib::Absolutepath $repo_export_dir = $katello::repo_export_dir,
  String $repo_export_dir_owner = $katello::user,
  String $repo_export_dir_group = $katello::group,
  Integer[0] $pulp_worker_timeout = $katello::pulp_worker_timeout,
  String $db_name = $katello::pulp_db_name,
  String $db_seeds = $katello::pulp_db_seeds,
  Optional[String] $db_username = $katello::pulp_db_username,
  Optional[String] $db_password = $katello::pulp_db_password,
  Optional[String] $db_replica_set = $katello::pulp_db_replica_set,
  Boolean $db_ssl = $katello::pulp_db_ssl,
  Optional[Stdlib::Absolutepath] $db_ssl_keyfile = $katello::pulp_db_ssl_keyfile,
  Optional[Stdlib::Absolutepath] $db_ssl_certfile = $katello::pulp_db_ssl_certfile,
  Boolean $db_verify_ssl = $katello::pulp_db_verify_ssl,
  Stdlib::Absolutepath $db_ca_path = $katello::pulp_db_ca_path,
  Boolean $db_unsafe_autoretry = $katello::pulp_db_unsafe_autoretry,
  Optional[Enum['majority', 'all']] $db_write_concern = $katello::pulp_db_write_concern,
  Boolean $manage_db = $katello::pulp_manage_db,
  String $pub_dir_options = '+FollowSymLinks +Indexes',
) {
  include certs
  include certs::qpid_client
  include apache

  # Deploy as a part of the foreman vhost
  include foreman
  $server_name = $foreman::servername
  foreman::config::passenger::fragment { 'pulp':
    content     => template('katello/pulp-apache.conf.erb'),
    ssl_content => template('katello/pulp-apache-ssl.conf.erb'),
  }

  class { 'pulp':
    server_name            => $server_name,
    messaging_url          => $messaging_url,
    messaging_ca_cert      => $certs::qpid_client::qpid_client_ca_cert,
    messaging_client_cert  => $certs::qpid_client::qpid_client_cert,
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
    enable_rpm             => $enable_yum,
    enable_iso             => $enable_file,
    enable_deb             => $enable_deb,
    enable_puppet          => $enable_puppet,
    enable_docker          => $enable_docker,
    enable_ostree          => $enable_ostree,
    num_workers            => $num_workers,
    enable_parent_node     => false,
    repo_auth              => true,
    puppet_wsgi_processes  => 1,
    enable_katello         => true,
    subscribe              => Class['certs', 'certs::qpid_client'],
    worker_timeout         => $pulp_worker_timeout,
    db_name                => $db_name,
    db_seeds               => $db_seeds,
    db_username            => $db_username,
    db_password            => $db_password,
    db_replica_set         => $db_replica_set,
    db_ssl                 => $db_ssl,
    db_ssl_keyfile         => $db_ssl_keyfile,
    db_ssl_certfile        => $db_ssl_certfile,
    db_verify_ssl          => $db_verify_ssl,
    db_ca_path             => $db_ca_path,
    db_unsafe_autoretry    => $db_unsafe_autoretry,
    db_write_concern       => $db_write_concern,
    manage_db              => $manage_db,
  }

  contain pulp

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

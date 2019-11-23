# Katello configuration for pulp
class katello::pulp (
  Optional[String] $yum_max_speed = $katello::pulp_max_speed,
  Boolean $enable_ostree = $katello::enable_ostree,
  Boolean $enable_yum = $katello::enable_yum,
  Boolean $enable_file = $katello::enable_file,
  Boolean $enable_puppet = $katello::enable_puppet,
  Boolean $enable_docker = $katello::enable_docker,
  Boolean $enable_deb = $katello::enable_deb,
  Integer[1] $num_workers = $katello::num_pulp_workers,
  Stdlib::Host $broker_host = katello::qpid_hostname,
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
  # Deploy as a part of the foreman vhost
  include foreman
  $server_name = $foreman::servername
  foreman::config::apache::fragment { 'pulp':
    content     => template('katello/pulp-apache.conf.erb'),
    ssl_content => template('katello/pulp-apache-ssl.conf.erb'),
  }

  class { 'foreman_proxy_content::pulp':
    is_mirror                => false,
    enable_ostree            => $enable_ostree,
    enable_yum               => $enable_yum,
    enable_file              => $enable_file,
    enable_puppet            => $enable_puppet,
    enable_docker            => $enable_docker,
    enable_deb               => $enable_deb,
    yum_max_speed            => $yum_max_speed,
    num_workers              => $num_workers,
    worker_timeout           => $pulp_worker_timeout,
    broker_host              => $broker_host,
    server_name              => $server_name,
    mongodb_name             => $db_name,
    mongodb_seeds            => $db_seeds,
    mongodb_username         => $db_username,
    mongodb_password         => $db_password,
    mongodb_replica_set      => $db_replica_set,
    mongodb_ssl              => $db_ssl,
    mongodb_ssl_keyfile      => $db_ssl_keyfile,
    mongodb_ssl_certfile     => $db_ssl_certfile,
    mongodb_verify_ssl       => $db_verify_ssl,
    mongodb_ca_path          => $db_ca_path,
    mongodb_unsafe_autoretry => $db_unsafe_autoretry,
    mongodb_write_concern    => $db_write_concern,
    manage_mongodb           => $manage_db,
  }
  contain foreman_proxy_content::pulp

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

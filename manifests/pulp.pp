# Katello configuration for pulp
class katello::pulp {
  include ::certs::qpid_client
  # Because we re-use the CRL file
  include ::katello::candlepin

  class { '::pulp':
    oauth_enabled          => true,
    oauth_key              => $::katello::oauth_key,
    oauth_secret           => $::katello::oauth_secret,
    messaging_url          => 'ssl://localhost:5671',
    messaging_ca_cert      => $::certs::ca_cert,
    messaging_client_cert  => $::certs::qpid_client::messaging_client_cert,
    messaging_transport    => 'qpid',
    messaging_auth_enabled => false,
    broker_url             => 'qpid://localhost:5671',
    broker_use_ssl         => true,
    consumers_crl          => $::candlepin::crl_file,
    proxy_url              => $::katello::proxy_url,
    proxy_port             => $::katello::proxy_port,
    proxy_username         => $::katello::proxy_username,
    proxy_password         => $::katello::proxy_password,
    yum_max_speed          => $::katello::pulp_max_speed,
    manage_broker          => false,
    manage_httpd           => false,
    manage_plugins_httpd   => true,
    manage_squid           => true,
    enable_rpm             => true,
    enable_puppet          => true,
    enable_docker          => true,
    enable_ostree          => $::katello::enable_ostree,
    num_workers            => $::katello::num_pulp_workers,
    max_tasks_per_child    => $::katello::max_tasks_per_pulp_worker,
    enable_parent_node     => false,
    repo_auth              => true,
    puppet_wsgi_processes  => 1,
    enable_katello         => true,
    subscribe              => Class['certs::qpid_client'],
  }

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

  file { $katello::repo_export_dir:
    ensure => directory,
    owner  => $katello::user,
    group  => $katello::group,
    mode   => '0755',
  }
}

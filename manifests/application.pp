# @summary Install and configure the katello application itself
#
# @param rest_client_timeout
#   Timeout for Katello rest API
#
# @param use_pulp_2_for_file
#  Configure Katello to use Pulp 2 for file content
#
# @param use_pulp_2_for_docker
#  Configure Katello to use Pulp 2 for docker content
#
# @param repo_export_dir
#   Create a repository export directory for Katello to use
#
class katello::application (
  Integer[0] $rest_client_timeout = 3600,
  Boolean $use_pulp_2_for_file = false,
  Boolean $use_pulp_2_for_docker = false,
  Stdlib::Absolutepath $repo_export_dir = '/var/lib/pulp/katello-export',
) {
  include foreman
  include certs
  include certs::apache
  include certs::candlepin
  include certs::foreman
  include certs::pulp_client
  include katello::params

  if $facts['os']['release']['major'] == '7' {
    include certs::qpid
    include katello::qpid_client
    User<|title == $foreman::user|>{groups +> 'qpidd'}

    Class['certs', 'certs::ca', 'certs::qpid'] ~> Class['foreman::plugin::tasks']
  }

  foreman_config_entry { 'pulp_client_cert':
    value          => $certs::pulp_client::client_cert,
    ignore_missing => false,
    require        => [Class['certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => $certs::pulp_client::client_key,
    ignore_missing => false,
    require        => [Class['certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  include foreman::plugin::tasks

  Class['certs', 'certs::ca', 'certs::apache'] ~> Class['apache::service']

  # Used in katello.yaml.erb
  $enable_ostree = $katello::params::enable_ostree
  $enable_yum = $katello::params::enable_yum
  $enable_file = $katello::params::enable_file
  $enable_puppet = $katello::params::enable_puppet
  $enable_docker = $katello::params::enable_docker
  $enable_deb = $katello::params::enable_deb
  $pulp_url = $katello::params::pulp_url
  $pulp_ca_cert = $certs::katello_server_ca_cert # TODO: certs::apache::...
  $candlepin_url = $katello::params::candlepin_url
  $candlepin_oauth_key = $katello::params::candlepin_oauth_key
  $candlepin_oauth_secret = $katello::params::candlepin_oauth_secret
  $candlepin_ca_cert = $certs::ca_cert
  $candlepin_events_ssl_cert = $certs::candlepin::client_cert
  $candlepin_events_ssl_key = $certs::candlepin::client_key
  $crane_url = $katello::params::crane_url
  $crane_ca_cert = $certs::katello_server_ca_cert
  $postgresql_evr_package = $katello::params::postgresql_evr_package
  $manage_db = $foreman::db_manage

  # Katello database seeding needs candlepin
  Anchor <| title == 'katello::repo' or title ==  'katello::candlepin' |> ->
  foreman::plugin { 'katello':
    package     => $foreman::plugin_prefix.regsubst(/foreman_/, 'katello'),
    config      => template('katello/katello.yaml.erb'),
    config_file => "${foreman::plugin_config_dir}/katello.yaml",
  }

  if $manage_db {
    package { $postgresql_evr_package:
      ensure => installed,
    }
  }

  foreman::config::apache::fragment { 'katello':
    ssl_content => file('katello/katello-apache-ssl.conf'),
  }

  if $foreman::jobs_manage_service {
    foreman::dynflow::worker { 'worker-hosts-queue':
      queues => ['hosts_queue'],
    }
  }

  Anchor <| title == 'katello::pulp' |> ->
  exec { "mkdir -p ${repo_export_dir}":
    path    => ['/bin', '/usr/bin'],
    creates => $repo_export_dir,
  } ->
  file { $repo_export_dir:
    ensure => directory,
    owner  => $foreman::user,
    group  => $foreman::group,
    mode   => '0755',
  }
}

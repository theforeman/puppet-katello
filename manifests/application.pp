# @summary Install and configure the katello application itself
#
# @param rest_client_timeout
#   Timeout for Katello rest API
#
class katello::application (
  Integer[0] $rest_client_timeout = 3600,
) {
  include foreman
  include certs
  include certs::apache
  include certs::candlepin
  include certs::foreman
  include certs::pulp_client
  include katello::params

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
  $agent_broker_url = $katello::params::qpid_url
  $agent_event_queue_name = $katello::params::agent_event_queue_name
  $enable_yum = $katello::params::enable_yum
  $enable_file = $katello::params::enable_file
  $enable_docker = $katello::params::enable_docker
  $enable_deb = $katello::params::enable_deb
  $candlepin_url = $katello::params::candlepin_url
  $candlepin_oauth_key = $katello::params::candlepin_oauth_key
  $candlepin_oauth_secret = $katello::params::candlepin_oauth_secret
  $candlepin_ca_cert = $certs::ca_cert
  $candlepin_events_ssl_cert = $certs::candlepin::client_cert
  $candlepin_events_ssl_key = $certs::candlepin::client_key
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
}

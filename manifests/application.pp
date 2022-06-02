# @summary Install and configure the katello application itself
#
# @param rest_client_timeout
#   Timeout for Katello rest API
#
# @param hosts_queue_workers
#   The number of workers handling the hosts_queue queue.
#
class katello::application (
  Integer[0] $rest_client_timeout = 3600,
  Integer[0] $hosts_queue_workers = 1,
) {
  include foreman
  include certs
  include certs::apache
  include certs::candlepin
  include certs::foreman
  include katello::params

  include foreman::plugin::tasks

  Class['certs', 'certs::ca', 'certs::apache'] ~> Class['apache::service']

  # Used in katello.yaml.erb
  $agent_broker_url = $katello::params::qpid_url
  $agent_event_queue_name = $katello::params::agent_event_queue_name
  $agent_broker_client_key = $certs::foreman::client_key
  $agent_broker_client_cert = $certs::foreman::client_cert
  $agent_broker_ca_cert = $certs::ca_cert
  $enable_katello_agent = $katello::params::enable_katello_agent
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

  # required by configuration in katello-apache-ssl.conf
  include apache::mod::setenvif

  foreman::config::apache::fragment { 'katello':
    ssl_content => file('katello/katello-apache-ssl.conf'),
  }

  if $foreman::dynflow_manage_services {
    foreman::dynflow::pool { 'worker-hosts-queue':
      instances => $hosts_queue_workers,
      queues    => ['hosts_queue'],
    }
  }
}

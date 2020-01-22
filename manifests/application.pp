# @summary Install and configure the katello application itself
#
# @param rest_client_timeout
#   Timeout for Katello rest API
#
# @param cdn_ssl_version
#  SSL version used to communicate with the CDN
#
# @param use_pulp_2_for_file
#  Configure Katello to use Pulp 2 for file content
#
# @param use_pulp_2_for_docker
#  Configure Katello to use Pulp 2 for docker content
#
class katello::application (
  Integer[0] $rest_client_timeout = 3600,
  Optional[Enum['SSLv23', 'TLSv1', '']] $cdn_ssl_version = undef,
  Boolean $use_pulp_2_for_file = false,
  Boolean $use_pulp_2_for_docker = false,
) {
  include foreman
  include certs
  include certs::apache
  include certs::foreman
  include certs::pulp_client
  include certs::qpid
  include katello::params

  include katello::qpid_client
  User<|title == $foreman::user|>{groups +> 'qpidd'}

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
  Class['certs', 'certs::ca', 'certs::qpid'] ~> Class['foreman::plugin::tasks']

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
  $qpid_url = "amqp:ssl:${katello::params::qpid_hostname}:5671"
  $candlepin_event_queue = $katello::params::candlepin_event_queue
  $crane_url = $katello::params::crane_url
  $crane_ca_cert = $certs::katello_server_ca_cert

  # Katello database seeding needs candlepin
  Anchor <| title == 'katello::repo' or title ==  'katello::candlepin' |> ->
  package { $katello::params::rubygem_katello:
    ensure => installed,
  } ->
  file { "${foreman::plugin_config_dir}/katello.yaml":
    ensure  => file,
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
    content => template('katello/katello.yaml.erb'),
    notify  => [Class['foreman::service'], Foreman::Rake['db:seed'], Foreman::Rake['apipie:cache:index']],
  }

  foreman::config::apache::fragment { 'katello':
    ssl_content => file('katello/katello-apache-ssl.conf'),
  }
}

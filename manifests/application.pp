# Install and configure the katello application itself
class katello::application (
  Array[String] $package_names = $::katello::package_names,
  Boolean $enable_ostree = $::katello::enable_ostree,
  String $rubygem_katello_ostree = $::katello::rubygem_katello_ostree,
  Optional[Enum['SSLv23', 'TLSv1', '']] $cdn_ssl_version = $::katello::cdn_ssl_version,
  String $deployment_url = $::katello::deployment_url,
  String $post_sync_token = $::katello::post_sync_token,
  Stdlib::Httpsurl $candlepin_url = $::katello::candlepin_url,
  String $candlepin_oauth_key = $::katello::candlepin_oauth_key,
  String $candlepin_oauth_secret = $::katello::candlepin_oauth_secret,
  String $pulp_oauth_key = $::katello::pulp_oauth_key,
  String $pulp_oauth_secret = $::katello::pulp_oauth_secret,
  Stdlib::Httpsurl $pulp_url = $::katello::pulp_url,
  String $qpid_url = $::katello::qpid_url,
  String $candlepin_event_queue = $::katello::candlepin_event_queue,
  Optional[String] $proxy_host = $::katello::proxy_url,
  Optional[Integer[0, 65535]] $proxy_port = $::katello::proxy_port,
  Optional[String] $proxy_username = $::katello::proxy_username,
  Optional[String] $proxy_password = $::katello::proxy_password,
) {
  include ::foreman
  include ::certs
  include ::certs::apache
  include ::certs::foreman
  include ::certs::pulp_client

  $post_sync_url = "${::foreman::foreman_url}${deployment_url}/api/v2/repositories/sync_complete?token=${post_sync_token}"
  $candlepin_ca_cert = $::certs::ca_cert
  $pulp_ca_cert = $::certs::katello_server_ca_cert

  foreman_config_entry { 'pulp_client_cert':
    value          => $::certs::pulp_client::client_cert,
    ignore_missing => false,
    require        => [Class['certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => $::certs::pulp_client::client_key,
    ignore_missing => false,
    require        => [Class['certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  # We used to override permissions here so this matches it back to the packaging
  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  include ::foreman::plugin::tasks

  Class['certs', 'certs::ca', 'certs::apache'] ~> Class['apache::service']

  # Katello database seeding needs candlepin
  package { $package_names:
    ensure => installed,
  } ->
  file { "${::foreman::plugin_config_dir}/katello.yaml":
    ensure  => file,
    owner   => 'root',
    group   => $::foreman::group,
    mode    => '0640',
    content => template('katello/katello.yaml.erb'),
    notify  => [Class['foreman::service', 'foreman::plugin::tasks'], Foreman::Rake['db:seed']],
  }

  if $enable_ostree {
    package { $rubygem_katello_ostree:
      ensure => installed,
      notify => [Class['foreman::service', 'foreman::plugin::tasks'], Foreman::Rake['apipie:cache:index']],
    }
  }

  foreman::config::passenger::fragment{ 'katello':
    ssl_content => file('katello/katello-apache-ssl.conf'),
  }
}

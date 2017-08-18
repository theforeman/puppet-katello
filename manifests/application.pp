# Install and configure the katello application itself
class katello::application (
  $package_names = $::katello::package_names,
  $enable_ostree = $::katello::enable_ostree,
  $rubygem_katello_ostree = $::katello::rubygem_katello_ostree,
  $cdn_ssl_version = $::katello::cdn_ssl_version,
  $deployment_url = $::katello::deployment_url,
  $post_sync_token = $::katello::post_sync_token,
  $candlepin_url = $::katello::candlepin_url,
  $oauth_key = $::katello::oauth_key,
  $oauth_secret = $::katello::oauth_secret,
  $pulp_url = $::katello::pulp_url,
  $qpid_url = $::katello::qpid_url,
  $candlepin_event_queue = $::katello::candlepin_event_queue,
  $proxy_host = $::katello::proxy_url,
  $proxy_port = $::katello::proxy_port,
  $proxy_username = $::katello::proxy_username,
  $proxy_password = $::katello::proxy_password,
) {
  include ::certs
  include ::certs::apache
  include ::certs::foreman
  include ::certs::pulp_client

  $candlepin_ca_cert = $::certs::ca_cert
  $pulp_ca_cert = $::certs::katello_server_ca_cert

  foreman_config_entry { 'pulp_client_cert':
    value          => $::certs::pulp_client::client_cert,
    ignore_missing => false,
    require        => [Class['::certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => $::certs::pulp_client::client_key,
    ignore_missing => false,
    require        => [Class['::certs::pulp_client'], Foreman::Rake['db:seed']],
  }

  # We used to override permissions here so this matches it back to the packaging
  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  include ::foreman
  include ::foreman::plugin::tasks

  Class['certs::ca', 'certs::apache'] ~> Class['apache::service']

  # Katello database seeding needs candlepin
  Exec <| tag == 'cpinit' |> ->
  package { $package_names:
    ensure => installed,
  } ->
  file { "${::foreman::plugin_config_dir}/katello.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
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

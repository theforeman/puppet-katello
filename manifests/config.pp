# Katello Config
class katello::config {

  $apache_version = $::apache::apache_version

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner  => $katello::user,
    group  => $katello::group,
    mode   => '0644',
  }

  file { "${katello::config_dir}/katello.yaml":
    ensure  => file,
    content => template('katello/katello.yaml.erb'),
    owner   => $katello::user,
    group   => $katello::group,
    mode    => '0644',
    before  => [Class['foreman::database'], Exec['foreman-rake-db:migrate']],
    notify  => [Service['foreman-tasks'], Class['foreman::service']],
  }

  foreman::config::passenger::fragment{ 'katello':
    content     => template('katello/etc/httpd/conf.d/05-foreman.d/katello.conf.erb'),
    ssl_content => template('katello/etc/httpd/conf.d/05-foreman-ssl.d/katello.conf.erb'),
  }

  file { "${katello::config_dir}/katello":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  foreman_config_entry { 'pulp_client_cert':
    value          => $::certs::pulp_client::client_cert,
    ignore_missing => false,
    require        => [Exec['foreman-rake-db:seed'], Class['::certs::pulp_client']],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => $::certs::pulp_client::client_key,
    ignore_missing => false,
    require        => [Exec['foreman-rake-db:seed'], Class['::certs::pulp_client']],
  }

}

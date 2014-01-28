# Katello Config
class katello::config {
  include katello::params

  group { $katello::user_groups:
    ensure => "present"
  } ~>
  user { $katello::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Katello',
    gid     => $katello::group,
    groups  => $katello::user_groups,
  }

  file { $katello::log_base:
    ensure  => directory,
    owner   => $katello::user,
    group   => $katello::user_groups,
    mode    => '0750',
  }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure  => file,
    owner   => $katello::user,
    group   => $katello::user_groups,
    mode    => '0644',
  }

  file { $katello::oauth_token_file:
    ensure  => file,
    content => $katello::oauth_secret,
    owner   => $katello::user,
    group   => $katello::user_groups,
    mode    => '0600',
  }

  # create Rails logs in advance to get correct owners and permissions
 # file {[
 #   "${katello::params::log_base}/production_delayed_jobs.log",
 #   "${katello::params::log_base}/production_delayed_jobs_sql.log",
 #     owner => $katello::user,
 #     group => $katello::group,
 #     content => '',
 #     replace => false,
 #     mode => '0640',
 # }

  file { "${katello::params::config_dir}/katello.yml":
    ensure => file,
    content => template("katello/${katello::params::config_dir}/katello.yml.erb"),
    owner => $katello::params::user,
    group => $katello::user_groups,
    mode => '0644',
    before => [Class['foreman::database'], Exec['foreman-rake-db:migrate']];
  }

  file { '/etc/sysconfig/katello':
    ensure  => file,
    content => template('katello/etc/sysconfig/katello.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/katello/client.conf':
    ensure  => file,
    content => template('katello/etc/katello/client.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

#  exec {"katello_db_printenv":
#    cwd         => $katello::params::katello_dir,
#    user        => $katello::params::user,
#    environment => "RAILS_ENV=${katello::params::environment}",
#    command     => "/usr/bin/env > ${katello::params::db_env_log}",
#    creates => "${katello::params::db_env_log}",
#    before  => Class["katello::service"],
#    require => $katello::params::deployment ? {
#                'katello' => [
#                  Class["candlepin::service"],
#                  Class["pulp::service"],
#                  Class["foreman"],
#                  File["${katello::params::log_base}"],
#                  File["${katello::params::log_base}/production.log"],
#                  File["${katello::params::log_base}/production_sql.log"],
#                  File["${katello::params::config_dir}/katello.yml"]
#                ],
#                'headpin' => [
#                  Class["candlepin::service"],
#                  Class["thumbslug::service"],
#                  Class["foreman"],
#                  File["${katello::params::log_base}"],
#                  File["${katello::params::config_dir}/katello.yml"]
#                ],
#                default => [],
#    },
#  }

}

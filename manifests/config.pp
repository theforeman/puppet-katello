# Katello Config
class katello::config {
  include katello::params

  group { $katello::group:
    ensure => "present"
  } ~>

  user { $katello::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Katello',
    gid     => $katello::group,
    groups  => $katello::user_groups,
  }

  # this should be required by all classes that need to log there (one of these)
  file {
    $katello::params::log_base:
      owner => $katello::params::user,
      group => $katello::params::group,
      mode => '0750';
    # this is a symlink when called via katello-configure
    $katello::params::configure_log_base:
      owner => $katello::params::user,
      group => $katello::params::group,
      mode => '0750';
  }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure => file,
    owner => $katello::params::user,
    group => $katello::user_groups,
    mode => '0644',
  }

  # create Rails logs in advance to get correct owners and permissions
  file {[
    "${katello::params::log_base}/production.log",
    "${katello::params::log_base}/production_sql.log",
    "${katello::params::log_base}/production_delayed_jobs.log",
    "${katello::params::log_base}/production_delayed_jobs_sql.log",
    "${katello::params::log_base}/production_orch.log",
    "${katello::params::log_base}/production_delayed_jobs_orch.log"]:
      owner => $katello::params::user,
      group => $katello::params::group,
      content => '',
      replace => false,
      mode => '0640',
  }

  file {
    "${katello::params::config_dir}/katello.yml":
      ensure => file,
      content => template("katello/${katello::params::config_dir}/katello.yml.erb"),
      owner => $katello::params::user,
      group => $katello::user_groups,
      mode => '0644',
      before => [Class['foreman::database'], Exec['foreman-rake-db:migrate']];

    '/etc/sysconfig/katello':
      content => template('katello/etc/sysconfig/katello.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644';

    '/etc/katello/client.conf':
      content => template('katello/etc/katello/client.conf.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644';
  }

#  exec { 'ktmigrate':
#    command     => "${foreman::app_root}/extras/dbmigrate",
#    user        => $foreman::user,
#    environment => "HOME=${foreman::app_root}",
#    logoutput   => 'on_failure',
#  } ->
  #File["/etc/sysconfig/katello"] ~> Exec["reload-apache"]
  #File["/etc/httpd/conf.d/katello.d"] ~>
  #File["/etc/httpd/conf.d/katello.d/katello.conf"] ~> Exec["reload-apache"]
  #File["/etc/httpd/conf.d/katello.conf"] ~> Exec["reload-apache"]


#  exec {"httpd-restart":
#    command => "/bin/sleep 5; /sbin/service httpd restart; /bin/sleep 10",
#    onlyif => "/usr/sbin/apachectl -t",
#    before => Exec["katello_seed_db"],
#    require   => $katello::params::deployment ? {
#        'katello' => [ File["${katello::params::config_dir}/katello.yml"], Class["candlepin::service"], Class["pulp::service"] ],
#        'headpin' => [ File["${katello::params::config_dir}/katello.yml"], Class["candlepin::service"], Class["thumbslug::service"] ],
#         default  => [],
#    },
#    refreshonly => true,
#  }
#
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
#
#  if $katello::params::reset_data == 'YES' {
#    exec {"reset_katello_db":
#      command => "rm -f /var/lib/katello/db_seed_done; rm -f /var/lib/katello/db_migrate_done; service katello stop; service katello-jobs stop; test 1 -eq 1",
#      path    => "/sbin:/bin:/usr/bin",
#      before  => Exec["katello_migrate_db"],
#      notify  => Postgresql::Dropdb["$katello::params::db_name"],
#    }
#    postgresql::dropdb {$katello::params::db_name:
#      logfile => "${katello::params::configure_log_base}/drop-postgresql-katello-database.log",
#      require => [ Postgresql::Createuser[$katello::params::db_user], File["${katello::params::configure_log_base}"] ],
#      before  => Exec["katello_migrate_db"],
#      refreshonly => true,
#      notify  => [
#        Postgresql::Createdb[$katello::params::db_name],
#        Exec["katello_db_printenv"],
#        Exec["katello_migrate_db"],
#        Exec["katello_seed_db"],
#      ],
#    }
#  }
#
#  exec {"katello_migrate_db":
#    cwd         => $katello::params::katello_dir,
#    user        => "root",
#    environment => ["RAILS_ENV=${katello::params::environment}", "BUNDLER_EXT_NOSTRICT=1"],
#    command     => "/usr/bin/${katello::params::scl_prefix}rake db:migrate --trace --verbose > ${katello::params::migrate_log} 2>&1 && touch /var/lib/katello/db_migrate_done",
#    creates => "/var/lib/katello/db_migrate_done",
#    before  => Class["katello::service"],
#    require => [ Exec["katello_db_printenv"] ],
#  }
#
#  exec {"katello_seed_db":
#    cwd         => $katello::params::katello_dir,
#    user        => "root",
#    environment => ["RAILS_ENV=${katello::params::environment}", "KATELLO_LOGGING=debug", "BUNDLER_EXT_NOSTRICT=1"],
#    command     => "/usr/bin/${katello::params::scl_prefix}rake seed_with_logging --trace --verbose > ${katello::params::seed_log} 2>&1 && touch /var/lib/katello/db_seed_done",
#    creates => "/var/lib/katello/db_seed_done",
#    before  => Class["katello::service"],
#    require => $katello::params::deployment ? {
#                'katello' => [ Exec["katello_migrate_db"], Class["candlepin::service"], Class["pulp::service"], File["${katello::params::log_base}"] ],
#                'headpin' => [ Exec["katello_migrate_db"], Class["candlepin::service"], Class["thumbslug::service"], File["${katello::params::log_base}"] ],
#                default => [],
#    },
#  }
#
#  # during first installation we mark all 'once'  upgrade scripts as executed
#  exec {"update_upgrade_history":
#    cwd     => "${katello::params::katello_upgrade_scripts_dir}",
#    command => "grep -E '#.*run:.*once' * | awk -F: '{print \$1}' > ${katello::params::katello_upgrade_history_file}",
#    creates => "${katello::params::katello_upgrade_history_file}",
#    path    => "/bin",
#    before  => Class["katello::service"],
#  }
#
#  # Headpin does not care about pulp
#  #case $katello::params::deployment {
#  #  'katello': {
#  #    Class["candlepin::config"] -> File["/etc/pulp/server.conf"]
#  #    Class["candlepin::config"] -> File["/etc/pulp/repo_auth.conf"]
#  #    Class["candlepin::config"] -> File["/etc/pki/pulp/content/pulp-global-repo.ca"]
#  #  }
#  #  default : {}
#  #}

}

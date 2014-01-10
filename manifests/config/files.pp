# Config Files for Katello
class katello::config::files {

  include katello::params

  # this should be required by all classes that need to log there (one of these)
  file {
    $katello::params::log_base:
      owner   => $katello::params::user,
      group   => $katello::params::group,
      mode    => '0750';
    # this is a symlink when called via katello-configure
    $katello::params::configure_log_base:
      owner   => $katello::params::user,
      group   => $katello::params::group,
      mode    => '0750';
  }

  file { '/usr/share/foreman/bundler.d/katello.rb':
    ensure  => file,
    owner   => $katello::params::user,
    group   => $katello::user_groups,
    mode    => '0644',
  }

  # create Rails logs in advance to get correct owners and permissions
  file {[
    "${katello::params::log_base}/production.log",
    "${katello::params::log_base}/production_sql.log",
    "${katello::params::log_base}/production_delayed_jobs.log",
    "${katello::params::log_base}/production_delayed_jobs_sql.log",
    "${katello::params::log_base}/production_orch.log",
    "${katello::params::log_base}/production_delayed_jobs_orch.log"]:
      owner   => $katello::params::user,
      group   => $katello::params::group,
      content => '',
      replace => false,
      mode    => '0640',
  }

  file {
    "${katello::params::config_dir}/katello.yml":
      ensure  => file,
      content => template("katello/${katello::params::config_dir}/katello.yml.erb"),
      owner   => $katello::params::user,
      group   => $katello::user_groups,
      mode    => '0644',
      before  => [Class['foreman::database'], Exec['foreman-rake-db:migrate']];

    '/etc/sysconfig/katello':
      content => template('katello/etc/sysconfig/katello.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

    '/etc/katello/client.conf':
      content => template('katello/etc/katello/client.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644';

#    "/etc/httpd/conf.d/katello.conf":
#      content => template("katello/etc/httpd/conf.d/katello.conf.erb"),
#      owner   => "root",
#      group   => "root",
#      mode    => "0644";
#
#    "/etc/httpd/conf.d/katello.d":
#      ensure  => directory,
#      owner   => "root",
#      group   => "root",
#      mode    => "0644";
#
#    "/etc/httpd/conf.d/katello.d/katello.conf":
#      content => template("katello/etc/httpd/conf.d/katello.d/katello.conf.erb"),
#      owner   => "root",
#      group   => "root",
#      mode    => "0644";
  }

}

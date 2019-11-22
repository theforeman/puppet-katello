# Katello configuration for pulp
# @api private
class katello::pulp (
  Stdlib::Absolutepath $repo_export_dir = $katello::repo_export_dir,
  String $repo_export_dir_owner = $katello::user,
  String $repo_export_dir_group = $katello::group,
  String $pub_dir_options = '+FollowSymLinks +Indexes',
) {
  # Deploy as a part of the foreman vhost
  include foreman
  foreman::config::apache::fragment { 'pulp':
    content     => template('katello/pulp-apache.conf.erb'),
    ssl_content => template('katello/pulp-apache-ssl.conf.erb'),
  }

  # NB: we define this here to avoid a dependency cycle. It is not a problem if
  # this dir exists before the pulp RPMs are installed.
  file { '/var/lib/pulp':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  }

  # Katello uses this export directory
  file { $repo_export_dir:
    ensure => directory,
    owner  => $repo_export_dir_owner,
    group  => $repo_export_dir_group,
    mode   => '0755',
  }
}

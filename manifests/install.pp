# Katello Install
class katello::install {

  if ! $katello::custom_repo {
    katello::install::repos { 'katello':
      repo     => $katello::repo,
      gpgcheck => $katello::gpgcheck,
    }
  }

  $repo = $katello::custom_repo ? {
    false   => [Katello::Install::Repos['katello']],
    default => []
  }

  $package = $::operatingsystem ? {
    'RHEL'   => 'ruby193-rubygem-katello',
    'CentOS' => 'ruby193-rubygem-katello',
    'Fedora' => 'rubygem-katello'
  }

  package{['katello', $package, 'pulp-katello-plugins']:
    ensure  => installed,
    require => $repo
  }

}

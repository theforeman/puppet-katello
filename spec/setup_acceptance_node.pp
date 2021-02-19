class { 'foreman::repo':
  repo => 'nightly',
}
class { 'katello::repo':
  repo_version => 'nightly',
}
class { 'candlepin::repo':
  version => 'nightly',
}

group { 'foreman':
  ensure => present,
}

if $facts['os']['release']['major'] == '7' {
  package { 'epel-release':
    ensure => installed,
  }
}

if $facts['os']['release']['major'] == '8' {
  # https://tickets.puppetlabs.com/browse/PUP-9978
  exec { '/usr/bin/dnf -y module enable pki-core':
  }

  package { 'glibc-langpack-en':
    ensure => installed,
  }

  yumrepo { 'katello_staging':
    descr    => "katello staging",
    baseurl  => "http://koji.katello.org/releases/yum/katello-nightly/katello/el8/x86_64/",
    enabled  => true,
    gpgcheck => false,
  }

  package { 'dnf-plugins-core':
    ensure => installed,
  } ~>
  exec { '/usr/bin/dnf config-manager --set-enabled powertools':
  }
}

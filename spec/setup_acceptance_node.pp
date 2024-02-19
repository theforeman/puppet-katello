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

file { '/etc/foreman':
  ensure => directory,
}

# Necessary for PostgreSQL EVR extension
yumrepo { 'pulpcore':
  baseurl  => "http://yum.theforeman.org/pulpcore/3.39/el\$releasever/\$basearch/",
  descr    => 'Pulpcore',
  enabled  => true,
  gpgcheck => true,
  gpgkey   => 'https://yum.theforeman.org/pulpcore/3.39/GPG-RPM-KEY-pulpcore',
}

package { 'glibc-langpack-en':
  ensure => installed,
}

yumrepo { 'powertools':
  enabled => true,
}

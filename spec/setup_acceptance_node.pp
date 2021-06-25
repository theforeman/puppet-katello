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
  ensure => directory
}

# Necessary for PostgreSQL EVR extension
yumrepo { "pulpcore":
  baseurl  => "http://yum.theforeman.org/pulpcore/3.14/el\$releasever/x86_64/",
  descr    => "Pulpcore",
  enabled  => true,
  gpgcheck => true,
  gpgkey   => "https://yum.theforeman.org/pulpcore/3.14/GPG-RPM-KEY-pulpcore",
}

if $facts['os']['release']['major'] == '8' {
  package { 'glibc-langpack-en':
    ensure => installed,
  }

  yumrepo { 'powertools':
    enabled => true,
  }
} elsif $facts['os']['release']['major'] == '7' {
  package { 'epel-release':
    ensure => installed,
  }
}

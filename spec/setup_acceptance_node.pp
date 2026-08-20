class { 'foreman::repo':
  repo => 'nightly',
}
class { 'katello::repo':
  repo_version => 'nightly',
}
class { 'candlepin::repo':
  version => if $facts['os']['release']['major'] == '9' { '4.8' } else { '5.0' }
}

group { 'foreman':
  ensure => present,
}

file { '/etc/foreman':
  ensure => directory,
}

package { 'glibc-langpack-en':
  ensure => installed,
}

if $facts['os']['release']['major'] == '8' {
  yumrepo { 'powertools':
    enabled => true,
  }
}

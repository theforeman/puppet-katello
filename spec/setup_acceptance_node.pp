class { 'foreman::repo':
  repo => 'nightly',
}
class { 'katello::repo':
  repo_version => 'nightly',
}
class { 'candlepin::repo':
  version => 'nightly',
}

if $facts['os']['release']['major'] == '8' {
  # https://tickets.puppetlabs.com/browse/PUP-9978
  exec { '/usr/bin/dnf -y module enable pki-core':
  }

  package { 'glibc-langpack-en':
    ensure => installed,
  }
}

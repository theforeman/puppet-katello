# gutterball plugin
class katello::plugin::gutterball{
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          $scl_prefix = ''
        }
        default: {
          $scl_prefix = 'ruby193-'
        }
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  Class[ 'certs' ] ->
  class { 'certs::gutterball': }

  class { '::gutterball':
    keystore_password => $certs::gutterball::gutterball_keystore_password,
  }

  if $foreman::plugin_prefix {
    Class[ 'certs::gutterball' ] ->
    foreman::plugin { 'gutterball': } ->
    Class[ '::gutterball' ]
  }
  else {
    Class[ 'certs::gutterball' ] ->
    package { "${scl_prefix}rubygem-foreman_gutterball":
      ensure => 'installed',
    } ->
    Class [ '::gutterball' ]
  }
}

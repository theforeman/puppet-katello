# @summary Katello qpid Config
#
class katello::qpid {
  class { 'qpid':
    ensure => 'absent',
    ssl    => false,
  }

  contain qpid
}

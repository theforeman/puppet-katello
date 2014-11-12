# Katello Install
class katello::install {
  if ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora'){
    $os = 'RHEL'
  } else {
    $os = 'Fedora'
  }
  $rubygem = $os ? {
    'RHEL'   => 'ruby193-rubygem-katello',
    'Fedora' => 'rubygem-katello'
  }
  package{['katello', $rubygem]:
    ensure => installed,
  }
}

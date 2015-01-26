# Katello Install
class katello::install {
  $scl_prefix = $katello::scl_prefix
  $scl_package_names = $katello::scl_package_names
  $scl_package_names_with_prefix = split(template('katello/sclpackages.erb'), ',')

  package { $katello::package_names:
    ensure => installed,
  }
  package { $scl_package_names_with_prefix:
    ensure => installed,
  }
}

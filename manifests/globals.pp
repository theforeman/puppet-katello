# @summary Katello Default Params
#
# @param enable_yum
#   Enable rpm content plugin, including syncing of yum content
#
# @param enable_file
#   Enable generic file content management
#
# @param enable_docker
#   Enable docker content plugin
#
# @param enable_deb
#   Enable debian content plugin
#
class katello::globals(
  Boolean $enable_yum = true,
  Boolean $enable_file = true,
  Boolean $enable_docker = true,
  Boolean $enable_deb = true,
) {
  # OAUTH settings
  $candlepin_oauth_key = 'katello'
  $candlepin_oauth_secret = extlib::cache_data('foreman_cache_data', 'candlepin_oauth_secret', extlib::random_password(32))

  if $facts['os']['release']['major'] == '7' {
    $postgresql_evr_package = 'rh-postgresql12-postgresql-evr'
  } else {
    $postgresql_evr_package = 'postgresql-evr'
  }
}

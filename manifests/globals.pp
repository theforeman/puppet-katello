# @summary Katello Default Params
#
# @param enable_katello_agent
#   Set to true to setup Qpid and katello-agent infrastructure.
#
class katello::globals (
  Katello::HieraBoolean $enable_katello_agent = false,
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

# @summary Katello Default Params
#
class katello::globals {
  # OAUTH settings
  $candlepin_oauth_key = 'katello'
  $candlepin_oauth_secret = extlib::cache_data('foreman_cache_data', 'candlepin_oauth_secret', extlib::random_password(32))
  $postgresql_evr_package = 'postgresql-evr'
}

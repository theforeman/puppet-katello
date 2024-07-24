# @summary An indirection layer for parameters
# @api private
#
# The goal of this class is to add all variables defined in katello::globals as
# class parameters. This will allow users of a distributed setup to override
# variables.
#
# This is a reversed model compared to the "regular" globals, but the
# parameters on globals are reserved for the foreman-installer
#
# @param candlepin_host
#   The host to run Candlepin as
# @param candlepin_url
#   The URL to connect to Candlepin
# @param candlepin_oauth_key
#   The oauth key for Candlepin
# @param candlepin_oauth_secret
#   The oauth secret for Candlepin
class katello::params (
  String[1] $candlepin_oauth_key = $katello::globals::candlepin_oauth_key,
  String[1] $candlepin_oauth_secret = $katello::globals::candlepin_oauth_secret,
  Stdlib::Host $candlepin_host = 'localhost',
  Stdlib::Port $candlepin_port = 23443,
  Stdlib::HTTPSUrl $candlepin_url = "https://${candlepin_host}:${candlepin_port}/candlepin",
  String[1] $candlepin_client_keypair_group = 'foreman',
  String[0] $meta_package = 'katello',
) inherits katello::globals {}

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
# @params agent_event_queue_name
#   Address which Katello Agent will process messages from
# @param candlepin_host
#   The host to run Candlepin as
# @param candlepin_url
#   The URL to connect to Candlepin
# @param qpid_hostname
#   QPID's hostname to connect
# @param qpid_url
#   Connection string with SSL derived from qpid_name
# @param candlepin_oauth_key
#   The oauth key for Candlepin
# @param candlepin_oauth_secret
#   The oauth secret for Candlepin
# @param postgresql_evr_package
#   The contextual package name for the PostgreSQL EVR extension
class katello::params (
  String[1] $agent_event_queue_name = 'katello.agent',
  Stdlib::Host $qpid_hostname = 'localhost',
  String[1] $qpid_url = "amqps://${qpid_hostname}:5671",
  String[1] $candlepin_oauth_key = $katello::globals::candlepin_oauth_key,
  String[1] $candlepin_oauth_secret = $katello::globals::candlepin_oauth_secret,
  Stdlib::Host $candlepin_host = 'localhost',
  Stdlib::Port $candlepin_port = 23443,
  Stdlib::HTTPSUrl $candlepin_url = "https://${candlepin_host}:${candlepin_port}/candlepin",
  String[1] $candlepin_client_keypair_group = 'foreman',
  String[1] $postgresql_evr_package = $katello::globals::postgresql_evr_package,
) inherits katello::globals {

  $enable_yum = $katello::globals::enable_yum != false
  $enable_file = $katello::globals::enable_file != false
  $enable_docker = $katello::globals::enable_docker != false
  $enable_deb = $katello::globals::enable_deb != false
  $enable_katello_agent = $katello::globals::enable_katello_agent != false

}

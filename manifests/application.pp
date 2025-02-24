# @summary Install and configure the katello application itself
#
# @param rest_client_timeout
#   Timeout for Katello rest API
#
# @param hosts_queue_workers
#   The number of workers handling the hosts_queue queue.
#
class katello::application (
  Integer[0] $rest_client_timeout = 3600,
  Integer[0] $hosts_queue_workers = 1,
) {
  include certs
  include certs::apache
  class { 'certs::foreman':
    deploy => false,
  }

  # Used in Candlepin
  $artemis_client_dn = katello::build_dn([['CN', $certs::foreman::hostname], ['OU', $certs::foreman::org_unit], ['O', $certs::foreman::org], ['ST', $certs::foreman::state], ['C', $certs::foreman::country]])
}

# Katello Default Params
class katello::params {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'Fedora': {
          $rubygem_katello = 'rubygem-katello'
          $rubygem_katello_ostree ='rubygem-katello_ostree'
        }
        default: {
          $rubygem_katello = 'tfm-rubygem-katello'
          $rubygem_katello_ostree ='tfm-rubygem-katello_ostree'
        }
      }

      $package_names = ['katello', $rubygem_katello]
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  $deployment_url = '/katello'

  # HTTP Proxy settings (currently used by pulp)
  $proxy_url = undef
  $proxy_port = undef
  $proxy_username = undef
  $proxy_password = undef

  $num_pulp_workers = min($::processorcount, 8)
  $max_tasks_per_pulp_worker = 2

  # Pulp max speed setting
  $pulp_max_speed = undef

  # Rest client timeout
  $rest_client_timeout = 3600

  # Pulp worker timeout
  $pulp_worker_timeout = 60

  # Qpid perf settings
  $qpid_wcache_page_size = 4

  # cdn ssl settings
  $cdn_ssl_version = undef

  # system settings
  $user = 'foreman'
  $group = 'foreman'
  $user_groups = ['foreman']
  $repo_export_dir = '/var/lib/pulp/katello-export'

  # OAUTH settings
  $candlepin_oauth_key = 'katello'
  $candlepin_oauth_secret = cache_data('foreman_cache_data', 'candlepin_oauth_secret', random_password(32))

  $post_sync_token = cache_data('foreman_cache_data', 'post_sync_token', random_password(32))

  # Subsystems settings
  $candlepin_url = "https://${::fqdn}:8443/candlepin"
  $pulp_url      = "https://${::fqdn}/pulp/api/v2/"

  # database reinitialization flag
  $reset_data = 'NONE'

  $qpid_hostname = 'localhost'
  $qpid_interface = 'lo'
  $qpid_url = "amqp:ssl:${qpid_hostname}:5671"
  $candlepin_event_queue = 'katello_event_queue'
  $candlepin_qpid_exchange = 'event'
  $enable_ostree = false
  $enable_yum = true
  $enable_file = true
  $enable_puppet = true
  $enable_docker = true
  $enable_deb = true

  $manage_repo = false
  $repo_version = 'latest'
  $repo_yumcode = "el${::operatingsystemmajrelease}"
  $repo_gpgcheck = false
  $repo_gpgkey = undef

  # candlepin database settings
  $candlepin_db_host = 'localhost'
  $candlepin_db_port = undef
  $candlepin_db_name = 'candlepin'
  $candlepin_db_user = 'candlepin'
  $candlepin_db_password = cache_data('foreman_cache_data', 'candlepin_db_password', random_password(32))
  $candlepin_db_ssl = false
  $candlepin_db_ssl_verify = true
  $candlepin_manage_db = true

  # pulp database settings
  $pulp_manage_db = true
  $pulp_db_name = 'pulp_database'
  $pulp_db_seeds = 'localhost:27017'
  $pulp_db_username = undef
  $pulp_db_password = undef
  $pulp_db_replica_set = undef
  $pulp_db_ssl = false
  $pulp_db_ssl_keyfile = undef
  $pulp_db_ssl_certfile = undef
  $pulp_db_verify_ssl = true
  $pulp_db_ca_path = '/etc/pki/tls/certs/ca-bundle.crt'
  $pulp_db_unsafe_autoretry = false
  $pulp_db_write_concern = undef
}

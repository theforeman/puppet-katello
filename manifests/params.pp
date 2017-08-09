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

  # Qpid perf settings
  $qpid_session_unacked = 10
  $qpid_wcache_page_size = 4

  # cdn ssl settings
  $cdn_ssl_version = undef

  # system settings
  $user = 'foreman'
  $group = 'foreman'
  $user_groups = ['foreman']
  $config_dir  = '/etc/foreman/plugins'
  $log_dir     = '/var/log/foreman/plugins'
  $repo_export_dir = '/var/lib/pulp/katello-export'

  # OAUTH settings
  $oauth_key = 'katello'
  $oauth_token_file = 'katello_oauth_secret'
  $oauth_secret = cache_data('foreman_cache_data', $oauth_token_file, random_password(32))

  $post_sync_token = cache_data('foreman_cache_data', 'post_sync_token', random_password(32))

  # Subsystems settings
  $candlepin_url = "https://${::fqdn}:8443/candlepin"
  $pulp_url      = "https://${::fqdn}/pulp/api/v2/"

  # database reinitialization flag
  $reset_data = 'NONE'

  $qpid_url = 'amqp:ssl:localhost:5671'
  $candlepin_event_queue = 'katello_event_queue'
  $candlepin_qpid_exchange = 'event'
  $enable_ostree = false

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
}

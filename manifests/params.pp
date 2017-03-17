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
  $max_tasks_per_pulp_worker = undef

  # Pulp max speed setting
  $pulp_max_speed = undef

  # cdn ssl settings
  $cdn_ssl_version = undef

  # advanced enable_*
  $enable_candlepin   = true
  $enable_qpid        = true
  $enable_qpid_client = true
  $enable_pulp        = true
  $enable_katello     = true

  # system settings
  $user = 'foreman'
  $group = 'foreman'
  $user_groups = 'foreman'
  $config_dir  = '/etc/foreman/plugins'
  $log_dir     = '/var/log/foreman/plugins'
  $repo_export_dir = '/var/lib/pulp/katello-export'

  # OAUTH settings
  $oauth_key = 'katello'
  $oauth_token_file = 'katello_oauth_secret'
  $oauth_secret = cache_data('foreman_cache_data', $oauth_token_file, random_password(32))

  $post_sync_token = cache_data('foreman_cache_data', 'post_sync_token', random_password(32))

  # Subsystems settings
  $candlepin_host     = $::fqdn
  #$candlepin_url     set in init.pp 
  $pulp_host          = $::fqdn
  #$pulp_url          set in init.pp
  $mongodb_path       = '/var/lib/mongodb'

  # database reinitialization flag
  $reset_data = 'NONE'

  $qpid_host = 'localhost'
  #$qpid_url set in init.pp
  $candlepin_event_queue = 'katello_event_queue'
  $enable_ostree = false
}

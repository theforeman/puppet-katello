# Katello Default Params
class katello::params {

  $custom_repo = false
  $repo = 'nightly'

  $deployment_url = '/katello'

  case $deployment_url {
      '/katello': {
        $deployment = 'katello'
      }
      '/headpin': {
        $deployment = 'headpin'
      }
      default : {
        $deployment = 'katello'
      }
  }

  # HTTP Proxy settings (currently used by pulp)
  $proxy_url = 'NONE'
  $proxy_port = 'NONE'
  $proxy_user = 'NONE'
  $proxy_pass = 'NONE'

  # system settings
  $host        = ''
  $user        = 'katello'
  $user_groups = 'foreman'
  $config_dir  = '/etc/katello'
  $katello_dir = '/usr/share/katello'
  $environment = 'production'
  $log_dir     = '/var/log/katello'
  $log_base    = '/var/log/katello'
  $configure_log_base = "${log_base}/katello-install"

  # katello upgrade settings
  $katello_upgrade_scripts_dir  = '/usr/share/katello/install/upgrade-scripts'
  $katello_upgrade_history_file = '/var/lib/katello/upgrade-history'

  # SSL settings
  $ssl_certificate_file     = '/etc/candlepin/certs/candlepin-ca.crt'
  $ssl_certificate_key_file = '/etc/candlepin/certs/candlepin-ca.key'
  $ssl_certificate_ca_file  = $ssl_certificate_file

  # sysconfig settings
  $job_workers = 1

  # OAUTH settings
  $oauth_key    = 'katello'

  # we set foreman oauth key to foreman, so that katello knows where the call
  # comes from and can find the rigth secret. This way only one key-secret pair
  # is needed to be mainained for duplex communication.
  $oauth_token_file = '/etc/katello/oauth_token-file'
  $oauth_secret     = generate_password

  # Subsystems settings
  $candlepin_url = 'https://localhost:8443/candlepin'
  $pulp_url      = subsystem_url('pulp/api/v2/')

  # database reinitialization flag
  $reset_data = 'NONE'

  $use_foreman = false
  $ldap_roles = false
  $validate_ldap = false
}

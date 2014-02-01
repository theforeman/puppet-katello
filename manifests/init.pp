# == Class: katello
#
# Install and configure katello
#
# === Parameters:
#
# $user::               The Katello system user name;
#                       default 'katello'
#
# $group::              The Katello system user group;
#                       default 'katello'
#
# $user_groups::        Extra user groups the Katello user is a part of;
#                       default 'foreman
#
# $oauth_key::          The oauth key for talking to the candlepin API;
#                       default 'katello'
#
# $oauth_secret::       The oauth secret for talking to the candlepin API;
#
# $log_dir::            Location for Katello log files to be placed
#
# $config_dir::         Location for Katello configurations to be placed
#
# $custom_repo::        If set to true, no repo will be added allowing custom installation
#                       type: boolean
#
# $repo::               This can currently only be nightly
#                       type: string
#
# $job_workers:: 	      The number of workers to used for delayed jobs
#
class katello (

  $user = $katello::params::user,
  $group = $katello::params::group,
  $user_groups = $katello::params::user_groups,

  $oauth_key = $katello::params::oauth_key,
  $oauth_secret = $katello::params::oauth_secret,

  $log_dir = $katello::params::log_dir,
  $config_dir = $katello::params::config_dir,

  $custom_repo = $katello::params::custom_repo,
  $repo = $katello::params::repo,

  $job_workers = $katello::params::job_workers

  ) inherits katello::params {

  class { 'katello::install': } ~>
  class { 'certs': 
    deploy      => true,
    generate    => true,
    custom_repo => $custom_repo
  }
  class { 'certs::apache': } ~>
  class { 'certs::katello': } ~>
  class { 'katello::config': } ~>
  class { 'katello::service': } ~>
  Exec['foreman-rake-db:seed']

  class { '::certs::pulp_parent': } ~>
  class { 'pulp':
    oauth_key     => $katello::oauth_key,
    oauth_secret  => $katello::oauth_secret,
    messaging_url => 'ssl://localhost:5671',
    before        => Exec['foreman-rake-db:seed']
  }

  class { 'candlepin':
    user_groups    => $katello::user_groups,
    oauth_key      => $katello::oauth_key,
    oauth_secret   => $katello::oauth_secret,
    deployment_url => 'katello',
    before         => Exec['foreman-rake-db:seed']
  }

  class{ 'elasticsearch':
    before         => Exec['foreman-rake-db:seed']
  }
}

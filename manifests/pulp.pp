# Katello configuration for pulp
#
# @param mongodb_name
#   Name of the database to use
#
# @param mongodb_seeds
#   Comma-separated list of hostname:port of database replica seed hosts
#
# @param mongodb_username
#   The user name to use for authenticating to the MongoDB server
#
# @param mongodb_password
#   The password to use for authenticating to the MongoDB server
#
# @param mongodb_replica_set
#   The name of replica set configured in MongoDB, if one is in use
#
# @param mongodb_ssl
#   Whether to connect to the database server using SSL.
#
# @param mongodb_ssl_keyfile
#   A path to the private keyfile used to identify the local connection against
#   mongod. If included with the certfile then only the ssl_certfile is needed.
#
# @param mongodb_ssl_certfile
#   The certificate file used to identify the local connection against mongod.
#
# @param mongodb_verify_ssl
#   Specifies whether a certificate is required from the other side of the
#   connection, and whether it will be validated if provided. If it is true,
#   then the ca_certs parameter must point to a file of CA certificates used to
#   validate the connection.
#
# @param mongodb_ca_path
#   The ca_certs file contains a set of concatenated "certification authority"
#   certificates, which are used to validate certificates passed from the other
#   end of the connection.
#
# @param mongodb_unsafe_autoretry
#  If true, retry commands to the database if there is a connection error.
#  Warning: if set to true, this setting can result in duplicate records.
#
# @param mongodb_write_concern
#   Write concern of 'majority' or 'all'. When 'all' is specified, 'w' is set
#   to number of seeds specified.  Please note that 'all' will cause Pulp to
#   halt if any of the replica set members is not available. 'majority' is used
#   by default
#
# @param manage_mongodb
#   Boolean to install and configure the mongodb.
#
# @param num_workers
#   The number of Pulp workers to use
#
# @param worker_timeout
#   The amount of time (in seconds) before considering a worker as missing. If
#   Pulp's mongo database has slow I/O, then setting a higher number may
#   resolve issues where workers are going missing incorrectly.
#
# @param yum_max_speed
#   The maximum download speed per second for a Pulp task, such as a sync. (e.g. "4 Kb" (Uses SI KB), 4MB, or 1GB" )
#
# @param pub_dir_options
#   The Apache options to use on the `/pub` resource
#
class katello::pulp (
  Optional[String] $yum_max_speed = undef,
  Optional[Integer[1]] $num_workers = undef,
  Integer[0] $worker_timeout = 60,
  String $mongodb_name = 'pulp_database',
  String $mongodb_seeds = 'localhost:27017',
  Optional[String] $mongodb_username = undef,
  Optional[String] $mongodb_password = undef,
  Optional[String] $mongodb_replica_set = undef,
  Boolean $mongodb_ssl = false,
  Optional[Stdlib::Absolutepath] $mongodb_ssl_keyfile = undef,
  Optional[Stdlib::Absolutepath] $mongodb_ssl_certfile = undef,
  Boolean $mongodb_verify_ssl = true,
  Stdlib::Absolutepath $mongodb_ca_path = '/etc/pki/tls/certs/ca-bundle.crt',
  Boolean $mongodb_unsafe_autoretry = false,
  Optional[Enum['majority', 'all']] $mongodb_write_concern = undef,
  Boolean $manage_mongodb = true,
  String $pub_dir_options = '+FollowSymLinks +Indexes',
) {
  include katello::params
  include certs

  class { 'certs::qpid_client':
    require => Class['pulp::install'],
    notify  => Class['pulp::service'],
  }

  include apache

  # Deploy as a part of the foreman vhost
  include foreman::config::apache
  $server_name = $foreman::config::apache::servername
  foreman::config::apache::fragment { 'pulp':
    content     => template('katello/pulp-apache.conf.erb'),
    ssl_content => template('katello/pulp-apache-ssl.conf.erb'),
  }

  Anchor <| title == 'katello::repo' |> -> # lint:ignore:anchor_resource
  class { 'pulp':
    server_name            => $server_name,
    messaging_url          => "ssl://${katello::params::qpid_hostname}:5671",
    messaging_ca_cert      => $certs::qpid_client::qpid_client_ca_cert,
    messaging_client_cert  => $certs::qpid_client::qpid_client_cert,
    messaging_transport    => 'qpid',
    messaging_auth_enabled => false,
    broker_url             => "qpid://${katello::params::qpid_hostname}:5671",
    broker_use_ssl         => true,
    yum_max_speed          => $yum_max_speed,
    manage_broker          => false,
    manage_httpd           => false,
    manage_plugins_httpd   => true,
    manage_squid           => true,
    enable_rpm             => $katello::params::enable_yum,
    enable_iso             => $katello::params::enable_file,
    enable_deb             => $katello::params::enable_deb,
    enable_puppet          => $katello::params::enable_puppet,
    enable_docker          => $katello::params::enable_docker,
    enable_ostree          => $katello::params::enable_ostree,
    num_workers            => $num_workers,
    enable_parent_node     => false,
    repo_auth              => true,
    puppet_wsgi_processes  => 1,
    enable_katello         => true,
    subscribe              => Class['certs'],
    worker_timeout         => $worker_timeout,
    db_name                => $mongodb_name,
    db_seeds               => $mongodb_seeds,
    db_username            => $mongodb_username,
    db_password            => $mongodb_password,
    db_replica_set         => $mongodb_replica_set,
    db_ssl                 => $mongodb_ssl,
    db_ssl_keyfile         => $mongodb_ssl_keyfile,
    db_ssl_certfile        => $mongodb_ssl_certfile,
    db_verify_ssl          => $mongodb_verify_ssl,
    db_ca_path             => $mongodb_ca_path,
    db_unsafe_autoretry    => $mongodb_unsafe_autoretry,
    db_write_concern       => $mongodb_write_concern,
    manage_db              => $manage_mongodb,
  }

  contain pulp

  anchor { 'katello::pulp': # lint:ignore:anchor_resource
    require => Class['pulp'],
  }
}

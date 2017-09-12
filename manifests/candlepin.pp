# Katello configuration for candlepin
class katello::candlepin (
  Variant[Array[String], String] $user_groups = $::katello::user_groups,
  String $oauth_key = $::katello::oauth_key,
  String $oauth_secret = $::katello::oauth_secret,
  String $deployment_url = $::katello::deployment_url,
  String $db_host = $::katello::candlepin_db_host,
  Optional[Integer[0, 65535]] $db_port = $::katello::candlepin_db_port,
  String $db_name = $::katello::candlepin_db_name,
  String $db_user = $::katello::candlepin_db_user,
  String $db_password = $::katello::candlepin_db_password,
  Boolean $db_ssl = $::katello::candlepin_db_ssl,
  Boolean $db_ssl_verify = $::katello::candlepin_db_ssl_verify,
  Boolean $manage_db = $::katello::candlepin_manage_db,
  String $qpid_hostname = $::katello::qpid_hostname,
) {
  include ::certs
  include ::certs::qpid
  include ::certs::candlepin
  include ::katello::qpid_client

  class { '::candlepin':
    user_groups                  => $user_groups,
    oauth_key                    => $oauth_key,
    oauth_secret                 => $oauth_secret,
    deployment_url               => $deployment_url,
    ca_key                       => $::certs::ca_key,
    ca_cert                      => $::certs::ca_cert_stripped,
    keystore_password            => $::certs::candlepin::keystore_password,
    truststore_password          => $::certs::candlepin::keystore_password,
    enable_basic_auth            => false,
    consumer_system_name_pattern => '.+',
    adapter_module               => 'org.candlepin.katello.KatelloModule',
    amq_enable                   => true,
    amqp_keystore_password       => $::certs::candlepin::keystore_password,
    amqp_truststore_password     => $::certs::candlepin::keystore_password,
    amqp_keystore                => $::certs::candlepin::amqp_keystore,
    amqp_truststore              => $::certs::candlepin::amqp_truststore,
    qpid_hostname                => $qpid_hostname,
    qpid_ssl_cert                => $::certs::qpid::client_cert,
    qpid_ssl_key                 => $::certs::qpid::client_key,
    db_host                      => $db_host,
    db_port                      => $db_port,
    db_name                      => $db_name,
    db_user                      => $db_user,
    db_password                  => $db_password,
    db_ssl                       => $db_ssl,
    db_ssl_verify                => $db_ssl_verify,
    manage_db                    => $manage_db,
    subscribe                    => Class['certs', 'certs::qpid', 'certs::candlepin'],
  }

  contain ::candlepin

  file { '/etc/tomcat/keystore':
    ensure  => link,
    target  => $::certs::candlepin::keystore,
    owner   => 'tomcat',
    group   => $::certs::group,
    require => Class['candlepin::install', 'certs::candlepin'],
    notify  => Class['candlepin::service'],
  }
}

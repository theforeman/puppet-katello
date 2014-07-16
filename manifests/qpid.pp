# Katello Config
class katello::qpid (
  $client_cert            = "${certs::qpid::client_cert}",
  $client_key             = "${certs::qpid::client_key}"
){
  exec { 'create katello entitlments queue':
    command => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' add queue ${::katello::params::candlepin_event_queue} --durable",
    unless  => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' queues ${::katello::params::candlepin_event_queue}",
    path => "/usr/bin",
    logoutput => true
  }
  exec { 'bind katello entitlments queue to qpid exchange messages that deal with entitlements':
    command => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' bind event ${katello::params::candlepin_event_queue} '*.*'",
    onlyif => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://${::fqdn}:5671' queues ${::katello::params::candlepin_event_queue}",
    path => "/usr/bin",
    logoutput => true
  }

}

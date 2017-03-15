# Katello qpid Config
class katello::qpid (
  $client_cert,
  $client_key,
  $katello_user             = $::katello::user,
  $candlepin_event_queue    = $::katello::candlepin_event_queue,
  $candlepin_qpid_exchange  = $::katello::candlepin_qpid_exchange,
){
  if $katello_user == undef {
    fail('katello_user not defined')
  } else {
    Group['qpidd'] ->
    User<|title == $katello_user|>{groups +> 'qpidd'}
  }
  exec { 'create candlepin qpid exchange migrate':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' add exchange topic ${candlepin_qpid_exchange} --durable",
    unless    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' exchanges ${candlepin_qpid_exchange}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  }
  exec { 'create katello entitlements queue':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' add queue ${candlepin_event_queue} --durable",
    unless    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' queues ${candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ~>
  qpid::bind_event { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created']:
    ssl_cert => $client_cert,
    queue    => $candlepin_event_queue,
  }
}

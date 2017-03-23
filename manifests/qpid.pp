# Katello qpid Config
class katello::qpid (
  $client_cert,
  $client_key,
  $katello_user          = $::katello::user,
  $candlepin_event_queue = $::katello::candlepin_event_queue,
  $amqp_port             = $::katello::amqp_port,
){
  if $katello_user == undef {
    fail('katello_user not defined')
  } else {
    Group['qpidd'] ->
    User<|title == $katello_user|>{groups +> 'qpidd'}
  }
  exec { 'delete katello entitlements queue if bound to *.*':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' del queue ${candlepin_event_queue} --force",
    onlyif    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:5671' list binding | grep ${candlepin_event_queue} | grep '*.*'",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ->
  exec { 'create katello entitlements queue':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' add queue ${candlepin_event_queue} --durable",
    unless    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' queues ${candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ~>
  qpid::bind_event { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created']:
    ssl_cert => $client_cert,
    queue    => $candlepin_event_queue,
    port     => $amqp_port,
  }
}

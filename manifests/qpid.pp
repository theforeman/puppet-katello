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
  exec { 'create katello entitlements queue':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' add queue ${candlepin_event_queue} --durable",
    unless    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' queues ${candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ->
  exec { 'bind katello entitlements queue to qpid exchange messages that deal with entitlements':
    command   => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' bind event ${candlepin_event_queue} '*.*'",
    onlyif    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' queues ${candlepin_event_queue}",
    unless    => "qpid-config --ssl-certificate ${client_cert} --ssl-key ${client_key} -b 'amqps://localhost:${amqp_port}' queues ${candlepin_event_queue} -r | /bin/grep '\[\*\.\*\]'",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  }

}

# Katello qpid Config
class katello::qpid (
  $client_cert            = undef,
  $client_key             = undef,
  $katello_user           = $katello::user
){
  if $katello_user == undef {
    fail('katello_user not defined')
  } else {
    Group['qpidd'] ->
    User<|title == $katello_user|>{groups +> 'qpidd'}
  }
   exec { 'delete katello entitlements queue if bound to *.*':
    command   => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://localhost:5671' del queue ${katello::candlepin_event_queue} --force",
    onlyif    => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://localhost:5671' list binding | grep ${katello::candlepin_event_queue} | grep '*.*'",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ->
  exec { 'create katello entitlments queue':
    command   => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://localhost:5671' add queue ${katello::candlepin_event_queue} --durable",
    unless    => "qpid-config --ssl-certificate ${katello::qpid::client_cert} --ssl-key ${katello::qpid::client_key} -b 'amqps://localhost:5671' queues ${katello::candlepin_event_queue}",
    path      => '/usr/bin',
    require   => Service['qpidd'],
    logoutput => true,
  } ->
  qpid::bind_event { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created']:
    ssl_cert => $katello::qpid::client_cert,
    ssl_key  => $katello::qpid::client_key,
    queue    => $katello::candlepin_event_queue,
  }
}

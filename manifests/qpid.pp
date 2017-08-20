# Katello qpid Config
class katello::qpid (
  $client_cert,
  $client_key,
  $katello_user            = $::katello::user,
  $candlepin_event_queue   = $::katello::candlepin_event_queue,
  $candlepin_qpid_exchange = $::katello::candlepin_qpid_exchange,
){
  if $katello_user == undef {
    fail('katello_user not defined')
  } else {
    Group['qpidd'] ->
    User<|title == $katello_user|>{groups +> 'qpidd'}
  }

  qpid::config_cmd {'delete katello entitlements queue if bound to *.*':
    command  => "del queue ${candlepin_event_queue} --force",
    onlyif   => "list binding | grep ${candlepin_event_queue} | grep '*.*'",
    ssl_cert => $client_cert,
    ssl_key  => $client_key,
  } ->
  qpid::queue { $candlepin_event_queue:
    ssl_cert => $client_cert,
    ssl_key  => $client_key,
  }

  qpid::config::bind { ['entitlement.created', 'entitlement.deleted', 'pool.created', 'pool.deleted', 'compliance.created']:
    queue    => $candlepin_event_queue,
    exchange => $candlepin_qpid_exchange,
    ssl_cert => $client_cert,
    ssl_key  => $client_key,
  }
}

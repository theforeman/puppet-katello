# Set up a qpid router
# @api private
class katello::qpid_router(
  $broker_addr = $katello::qpid_hostname,
) {
  class { 'foreman_proxy_content::dispatch_router':
    # TODO: were foreman_proxy_content class parameters
    #agent_addr    => ,
    #agent_port    => ,
    #ssl_ciphers   => ,
    #ssl_protocols => ,
    #logging_level => ,
    #logging       => ,
    #logging_path  => ,
  }

  class { 'foreman_proxy_content::dispatch_router::hub':
    broker_addr => $hostname,
  }
}

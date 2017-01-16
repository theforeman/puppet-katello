#Katello Pulp Client config
class katello::config::pulp_client {
  foreman_config_entry { 'pulp_client_cert':
    value          => '/etc/pki/pulp/cert.pem',
    ignore_missing => false,
    require        => Exec['foreman-rake-db:seed'],
  }

  foreman_config_entry { 'pulp_client_key':
    value          => '/etc/pki/pulp/key.pem',
    ignore_missing => false,
    require        => Exec['foreman-rake-db:seed'],
  }
}


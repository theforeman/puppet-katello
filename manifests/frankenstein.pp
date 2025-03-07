# @summary Install quadlets using Ansible
#
class katello::frankenstein (
) {
  # from foreman_proxy_content
  class { 'certs::foreman_proxy':
    generate => false,
    deploy => true,
  }
  Class['certs::foreman_proxy'] ~> Service['foreman-proxy']
  # end foreman_proxy_content
}


# @summary Install quadlets using Ansible
#
class katello::frankenstein (
) {
  # saving calling setup.yaml
  # python3.12 stuff as ansible is "funny"
  stdlib::ensure_packages(['ansible-core', 'git-core', 'podman', 'python3-cryptography', 'python3-libsemanage', 'python3-requests', 'bash-completion', 'nmap', 'python3.12-psycopg2', 'python3.12-requests'])

  # from foreman_proxy_content
  class { 'certs::foreman_proxy':
    deploy => true,
  }
  Class['certs::foreman_proxy'] ~> Service['foreman-proxy']
  # end foreman_proxy_content

  vcsrepo { '/opt/foreman-quadlet':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/theforeman/foreman-quadlet',
    revision => 'installer-certs',
  }
  -> exec { 'ansible-galaxy install -r requirements.yml':
    cwd => '/opt/foreman-quadlet',
    path => ['/usr/bin', '/usr/sbin'],
  }
  -> exec { 'ansible-playbook playbooks/deploy.yaml -e certificate_source=installer':
    cwd => '/opt/foreman-quadlet',
    path => ['/usr/bin', '/usr/sbin'],
    timeout => 1800,
  }
}


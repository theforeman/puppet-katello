# @summary Install quadlets using Ansible
#
class katello::frankenstein (
) {
  # saving calling setup.yaml
  # python3.12 stuff as ansible is "funny"
  # java so that puppet certs candlepin stuff doesn't go belly up
  stdlib::ensure_packages(['ansible-core', 'git-core', 'podman', 'python3-cryptography', 'python3-libsemanage', 'python3-requests', 'bash-completion', 'nmap', 'python3.12-psycopg2', 'python3.12-requests', 'java-17-openjdk'])

  # from foreman_proxy_content
  include certs::foreman_proxy
  Class['certs::foreman_proxy'] ~> Service['foreman-proxy']
  # end foreman_proxy_content

  # needed for certs to be deployable
  group { ['foreman', 'tomcat']: }
  file { ['/etc/foreman', '/etc/candlepin', '/etc/candlepin/certs']:
    ensure => directory
  }

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
  -> exec { 'ansible-playbook playbooks/deploy.yaml':
    cwd => '/opt/foreman-quadlet',
    path => ['/usr/bin', '/usr/sbin'],
    timeout => 1800,
  }
}


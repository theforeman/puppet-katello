# @summary Manage the Katello repository
#
# @param repo_version
#   The repository version to use
# @param dist
#   The distribution to use
# @param gpgcheck
#   Whether GPG signatures need to be checked
# @param gpgkey
#   The location of the GPG key
class katello::repo (
  Variant[Pattern[/^\d\.\d+$/], Enum['nightly']] $repo_version,
  String $dist = "el${facts['os']['release']['major']}",
  Boolean $gpgcheck = false,
  String $gpgkey = 'absent',
) {
  yumrepo { 'katello':
    descr    => "katello ${repo_version}",
    baseurl  => "https://yum.theforeman.org/katello/${repo_version}/katello/${dist}/\$basearch/",
    gpgkey   => $gpgkey,
    gpgcheck => $gpgcheck,
    enabled  => true,
  }
  -> anchor { 'katello::repo': } # lint:ignore:anchor_resource

  Anchor <| title == 'foreman::repo' |> -> Yumrepo['katello']

  if $facts['os']['release']['major'] == '8' {
    package { 'katello-dnf-module':
      ensure      => $dist,
      name        => 'katello',
      enable_only => true,
      provider    => 'dnfmodule',
      require     => Yumrepo['katello'],
      before      => Anchor['katello::repo'],
    }
  }
}

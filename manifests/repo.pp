# @summary Manage the Katello repository
#
# @param repo_version
#   The repository version to use. Either latest or a version like 3.14.
# @param dist
#   The distribution to use
# @param gpgcheck
#   Whether GPG signatures need to be checked
# @param gpgkey
#   The location of the GPG key
class katello::repo (
  String $repo_version = latest,
  String $dist = "el${facts['os']['release']['major']}",
  Boolean $gpgcheck = false,
  String $gpgkey = 'absent',
) {
  yumrepo { 'katello':
    descr    => "katello ${repo_version}",
    baseurl  => "https://fedorapeople.org/groups/katello/releases/yum/${repo_version}/katello/${dist}/\$basearch/",
    gpgkey   => $gpgkey,
    gpgcheck => $gpgcheck,
    enabled  => true,
  }
  -> anchor { 'katello::repo': } # lint:ignore:anchor_resource
}

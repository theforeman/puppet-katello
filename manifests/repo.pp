class katello::repo (
  Boolean $manage_repo = $katello::manage_repo,
  String $repo_version = $katello::repo_version,
  String $dist = $katello::repo_yumcode,
  Boolean $gpgcheck = $katello::repo_gpgcheck,
  Optional[String] $gpgkey = $katello::repo_gpgkey,
) {
  if $manage_repo {
    yumrepo { 'katello':
      descr    => "katello ${repo_version}",
      baseurl  => "https://fedorapeople.org/groups/katello/releases/yum/${repo_version}/katello/${dist}/\$basearch/",
      gpgkey   => $gpgkey,
      gpgcheck => $gpgcheck,
      enabled  => true,
    }
  }
}

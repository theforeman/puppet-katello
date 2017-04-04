class katello::repo (
  $manage_repo  = $::katello::manage_repo,
  $repo_version = $::katello::repo_version,
  $dist         = $::katello::repo_yumcode,
  $gpgcheck     = $::katello::repo_gpgcheck,
  $gpgkey       = $::katello::repo_gpgkey,
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

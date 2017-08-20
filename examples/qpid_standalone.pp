class { '::katello':
  enable_candlepin   => false,
  enable_qpid        => true,
  enable_qpid_client => false,
  enable_pulp        => false,
  enable_application => false,
}

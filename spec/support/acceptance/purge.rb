def purge_katello
  on default, 'yum -y remove foreman* tfm-*'
  on default, "systemctl stop httpd", { :acceptable_exit_codes => [0, 5] }
end

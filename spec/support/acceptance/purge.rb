def purge_katello
  on default, 'dnf -y remove foreman*'
  on default, "systemctl stop httpd", { :acceptable_exit_codes => [0, 5] }
end

# @summary Katello qpid Config
#
# @param interface
#   The interface to listen on
#
# @param wcache_page_size
#   The size (in KB) of the pages in the write page cache
#
class katello::qpid (
  String $interface = 'lo',
  Integer[0, 5000] $wcache_page_size = 4,
) {
  include certs
  include certs::qpid

  class { 'qpid':
    ssl                    => true,
    ssl_cert_db            => $certs::qpid::nss_db_dir,
    ssl_cert_password_file => $certs::qpid::nss_db_password_file,
    ssl_cert_name          => $certs::qpid::nss_cert_name,
    acl_content            => file('katello/qpid_acls.acl'),
    interface              => $interface,
    wcache_page_size       => $wcache_page_size,
    subscribe              => Class['certs', 'certs::qpid'],
  }

  contain qpid
}

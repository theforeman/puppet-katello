# @summary
#   Extracts a certificate's subject in RFC2253 form
#
# @example How to extract a certificate's subject
#   $cert_subject = katello::certificate_subject($path_to_certificate)
#
Puppet::Functions.create_function(:'katello::certificate_subject') do
  # @param certificate_path
  #
  # @return [String]
  dispatch :certificate_subject do
    param 'Stdlib::Absolutepath', :certificate_path
  end

  def certificate_subject(certificate_path)
    begin
      cert = OpenSSL::X509::Certificate.new(File.read(certificate_path))
      cert.subject.to_s(OpenSSL::X509::Name::RFC2253)
    rescue OpenSSL::X509::CertificateError, Errno::ENOENT
      nil
    end
  end
end

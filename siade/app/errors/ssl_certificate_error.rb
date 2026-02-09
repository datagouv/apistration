class SSLCertificateError < AbstractGenericProviderError
  def subcode
    '009'
  end

  def kind
    :provider_unknown_error
  end
end

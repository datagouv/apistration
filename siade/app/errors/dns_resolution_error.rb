class DnsResolutionError < AbstractGenericProviderError
  def subcode
    '004'
  end

  def kind
    :network_error
  end
end

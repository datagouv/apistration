class ProviderUnavailable < AbstractGenericProviderError
  def subcode
    '001'
  end

  def kind
    :network_error
  end
end

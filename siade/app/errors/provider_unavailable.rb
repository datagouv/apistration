class ProviderUnavailable < AbstractGenericProviderError
  def subcode
    '001'
  end

  def kind
    :provider_error
  end
end

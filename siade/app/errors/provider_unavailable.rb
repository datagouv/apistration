class ProviderUnavailable < AbstractGenericProviderError
  def subcode
    '001'
  end
end

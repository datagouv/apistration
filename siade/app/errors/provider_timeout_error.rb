class ProviderTimeoutError < AbstractGenericProviderError
  def subcode
    '002'
  end

  def kind
    :network_error
  end
end

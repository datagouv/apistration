class ProviderTimeoutError < AbstractGenericProviderError
  def subcode
    '002'
  end

  def kind
    :timeout_error
  end
end

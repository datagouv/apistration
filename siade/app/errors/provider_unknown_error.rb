class ProviderUnknownError < AbstractGenericProviderError
  def subcode
    '999'
  end

  def tracking_level
    'error'
  end

  def kind
    :provider_unknown_error
  end
end

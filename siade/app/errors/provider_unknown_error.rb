class ProviderUnknownError < AbstractGenericProviderError
  def subcode
    '999'
  end

  def tracking_level
    'error'
  end
end

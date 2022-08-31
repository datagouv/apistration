class ProviderUnknownError < ProviderInternalServerError
  def tracking_level
    'error'
  end
end

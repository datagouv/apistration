class ProviderRateLimitingError < ProviderUnavailable
  def subcode
    '007'
  end

  def tracking_level
    'error'
  end

  def detail
    'Erreur de fournisseur de donnée : Trop de requêtes effectuées, veuillez réessayer plus tard.'
  end
end

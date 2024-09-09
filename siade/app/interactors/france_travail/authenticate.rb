class FranceTravail::Authenticate < GetOAuth2Token
  private

  def client_url
    Siade.credentials[:france_travail_authenticate_url]
  end

  def scope
    [
      'api_statutaugmentev1',
      'api_liste-paiementsv1',
      'individuStatutAugmente',
      "application_#{client_id}"
    ].join(' ')
  end

  def client_id
    Siade.credentials[:france_travail_client_id]
  end

  def client_secret
    Siade.credentials[:france_travail_client_secret]
  end
end

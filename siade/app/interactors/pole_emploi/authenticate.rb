class PoleEmploi::Authenticate < GetOAuth2Token
  private

  def client_url
    Siade.credentials[:pole_emploi_authenticate_url]
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
    Siade.credentials[:pole_emploi_client_id]
  end

  def client_secret
    Siade.credentials[:pole_emploi_client_secret]
  end
end

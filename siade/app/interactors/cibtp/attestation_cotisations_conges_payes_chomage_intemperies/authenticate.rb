class CIBTP::AttestationCotisationsCongesPayesChomageIntemperies::Authenticate < GetOAuth2Token
  def client_url
    "#{Siade.credentials[:cibtp_domain]}/apientreprise/token"
  end

  def client_id
    Siade.credentials[:cibtp_client_id]
  end

  def client_secret
    Siade.credentials[:cibtp_client_secret]
  end

  private

  def cibtp_domain
    Siade.credentials[:cibtp_domain]
  end

  def request_params
    {
      client_id:,
      client_secret:
    }
  end

  def form_data
    {}
  end
end

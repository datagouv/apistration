class INPI::RNE::BeneficiairesEffectifs::MakeRequest < INPI::RNE::MakeRequest
  def request_uri
    URI("#{Siade.credentials[:inpi_rne_unites_legales_url]}/#{siren}")
  end
end

class PROBTP::AttestationsCotisationsRetraite::MakeRequest < PROBTP::MakeRequest
  protected

  def request_uri
    URI('https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getAttestationCotisation')
  end
end

class PROBTP::AttestationsCotisationsRetraite::MakeRequest < PROBTP::MakeRequest
  protected

  def request_uri
    URI("#{probtp_domain}/ws_ext/rest/certauth/mpsservices/getAttestationCotisation")
  end
end

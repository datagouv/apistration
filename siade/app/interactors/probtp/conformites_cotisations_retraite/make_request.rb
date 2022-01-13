class PROBTP::ConformitesCotisationsRetraite::MakeRequest < PROBTP::MakeRequest
  protected

  def request_uri
    URI("#{probtp_domain}/ws_ext/rest/certauth/mpsservices/getStatutCotisation")
  end
end

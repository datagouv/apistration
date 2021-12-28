class PROBTP::ConformitesCotisationsRetraite::MakeRequest < PROBTP::MakeRequest
  protected

  def request_uri
    URI('https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getStatutCotisation')
  end
end

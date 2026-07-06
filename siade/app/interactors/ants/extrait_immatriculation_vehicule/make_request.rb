class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  include UseWildcardSSLCertificate

  private

  def http_options
    http_wildcard_ssl_options
  end

  def extra_headers(request)
    request['Content-Type'] = 'application/json'
    request['X-Http-Method-Override'] = 'GET'
    request['Authorization'] = "Bearer #{context.token}"
  end

  def mocking_params
    {
      immatriculation: context.params[:immatriculation]
    }
  end

  def request_uri
    URI(Siade.credentials[:ants_siv2_url])
  end

  def request_params
    {}
  end

  def build_request_body
    { informations: }.to_json
  end

  def informations
    {
      numImmat: context.params[:immatriculation]&.upcase,
      nomNaiss: context.params[:nom_naissance],
      nomUsage: context.params[:nom_usage],
      prenom:,
      numeroDemande: numero_demande
    }.compact
  end

  def prenom
    Array(context.params[:prenoms]).join(' ').presence
  end

  def numero_demande
    context.params[:request_id] || SecureRandom.uuid
  end
end

class Infogreffe::MandatairesSociaux::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI('https://infogreffe_url_extrait_rcs.gouv.fr')
  end

  def build_request_body
    infogreffe_code_abonne = Siade.credentials[:infogreffe_code_abonne]
    infogreffe_mot_passe   = Siade.credentials[:infogreffe_mot_passe]

    ERB.new(erb_template_for_entreprise_request).result(binding)
  end

  def set_headers(request)
    request['Content-Type'] = 'text/xml'
    request['charset'] = 'utf-8'
    request['SOAPAction'] = 'getProduitsWebServicesXML'
  end

  private

  def siren
    context.params[:siren]
  end

  def erb_template_for_entreprise_request
    File.read(Rails.root.join('lib/siade/v2/requests/templates/entreprise_request.xml.erb'))
  end
end

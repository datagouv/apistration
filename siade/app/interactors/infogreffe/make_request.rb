class Infogreffe::MakeRequest < MakeRequest::Post
  protected

  def request_uri
    URI(infogreffe_url_extrait_rcs)
  end

  def build_request_body
    InfogreffeKbisSoapBuilder.new(siren).render
  end

  def set_headers(request)
    request['Content-Type'] = 'text/xml'
    request['charset'] = 'utf-8'
    request['SOAPAction'] = 'getProduitsWebServicesXML'
  end

  private

  def infogreffe_url_extrait_rcs
    Siade.credentials[:infogreffe_url_extrait_rcs]
  end

  def siren
    context.params[:siren]
  end
end

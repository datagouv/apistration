class ANTS::ExtraitImmatriculationVehicule::MakeRequest < MakeRequest::Post
  include UseWildcardSSLCertificate

  protected

  def mocking_params
    {
      immatriculation: context.params[:immatriculation]
    }
  end

  def request_uri
    URI(Siade.credentials[:ants_siv_url])
  end

  def request_params
    {}
  end

  def build_request_body
    ANTSDossierImmatriculationSoapBuilder.new(
      immatriculation: context.params[:immatriculation].upcase,
      request_id: context.params[:request_id],
      certificate: cert,
      private_key: key
    ).render
  end

  private

  def ants_domain
    Siade.credentials[:ants_domain]
  end
end

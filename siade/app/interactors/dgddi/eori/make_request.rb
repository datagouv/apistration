class DGDDI::EORI::MakeRequest < MakeRequest::Get
  protected

  def request_uri
    URI("#{uri}/#{siret_or_eori}")
  end

  def request_params
    {
      idClient: client_id
    }
  end

  private

  def client_id
    Siade.credentials[:douanes_client_id]
  end

  def uri
    Siade.credentials[:douanes_domain]
  end

  def siret_or_eori
    context.params[:siret_or_eori]
  end
end

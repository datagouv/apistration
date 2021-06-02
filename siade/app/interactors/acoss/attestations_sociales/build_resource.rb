class ACOSS::AttestationsSociales::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: context.params[:siren],
      document_url: context.url,
    }
  end
end

class PROBTP::AttestationsCotisationsRetraite::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      id: context.params[:siret],
      document_url: context.url,
    }
  end
end

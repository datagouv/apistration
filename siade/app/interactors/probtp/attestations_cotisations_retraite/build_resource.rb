class PROBTP::AttestationsCotisationsRetraite::BuildResource < BuildResource
  def call
    context.resource = Hashie::Mash.new(build_resource)
  end

  private

  def build_resource
    {
      id: context.params[:siret],
      document_url: context.url,
    }
  end
end

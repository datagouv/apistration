class QUALIBAT::CertificationsBatiment::BuildResource < BuildResource::Document
  def id
    context.params[:siret]
  end
end

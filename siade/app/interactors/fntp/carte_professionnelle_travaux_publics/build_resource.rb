class FNTP::CarteProfessionnelleTravauxPublics::BuildResource < BuildResource::Document
  def id
    context.params[:siren]
  end
end

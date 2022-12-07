class MI::UniteLegale < RetrieverOrganizer
  before do
    context.params[:siret_or_rna] = context.params[:siren_or_rna]
  end

  organize ValidateSirenOrRNA,
    MI::Associations::MakeRequest,
    MI::Associations::ValidateResponse,
    MI::Associations::BuildResource

  def provider_name
    'MI'
  end
end

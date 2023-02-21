class DJEPVA::UniteLegale < RetrieverOrganizer
  before do
    context.params[:siren_or_rna] = context.params[:id]
  end

  organize ValidateSirenOrRNA,
    MI::Associations::MakeRequest,
    MI::Associations::ValidateResponse,
    MI::Associations::BuildResource

  def provider_name
    'DJEPVA'
  end
end

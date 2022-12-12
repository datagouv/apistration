class MI::Associations < RetrieverOrganizer
  before do
    context.params[:siret_or_rna] = context.params[:id]
  end

  organize ValidateSiretOrRNA,
    MI::Associations::MakeRequest,
    MI::Associations::ValidateResponse,
    MI::Associations::BuildResource

  def provider_name
    'MI'
  end
end

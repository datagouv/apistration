class MI::Associations::Documents < RetrieverOrganizer
  before do
    context.params[:siret_or_rna] = context.params[:id]
  end

  organize ValidateSiretOrRNA,
    MI::Associations::MakeRequest,
    MI::Associations::Documents::ValidateResponse,
    MI::Associations::Documents::BuildResourceCollection

  def provider_name
    'MI'
  end
end

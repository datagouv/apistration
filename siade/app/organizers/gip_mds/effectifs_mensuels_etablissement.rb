class GIPMDS::EffectifsMensuelsEtablissement < RetrieverOrganizer
  before do
    context.params[:nature] = :monthly
  end

  organize GIPMDS::EffectifsMensuelsEtablissement::ValidateParams,
    GIPMDS::Authenticate,
    GIPMDS::Effectifs::MakeRequest,
    GIPMDS::Effectifs::ValidateResponse,
    GIPMDS::EffectifsMensuelsEtablissement::BuildResource

  def provider_name
    'GIP-MDS'
  end
end

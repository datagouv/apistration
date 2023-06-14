class GIPMDS::EffectifsMensuelsEtablissementForV2 < RetrieverOrganizer
  before do
    context.params[:nature] = :monthly
  end

  organize GIPMDS::EffectifsMensuelsEtablissement::ValidateParams,
    GIPMDS::Authenticate,
    GIPMDS::Effectifs::MakeRequest,
    GIPMDS::Effectifs::ValidateResponseForV2,
    GIPMDS::EffectifsMensuelsEtablissement::BuildResource

  def provider_name
    'GIP-MDS'
  end
end

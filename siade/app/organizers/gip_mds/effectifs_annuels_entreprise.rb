class GIPMDS::EffectifsAnnuelsEntreprise < RetrieverOrganizer
  before do
    context.params[:nature] = :yearly
  end

  organize GIPMDS::EffectifsAnnuelsEntreprise::ValidateParams,
    GIPMDS::Authenticate,
    GIPMDS::Effectifs::MakeRequest,
    GIPMDS::Effectifs::ValidateResponse,
    GIPMDS::EffectifsAnnuelsEntreprise::BuildResource

  def provider_name
    'GIP-MDS'
  end
end

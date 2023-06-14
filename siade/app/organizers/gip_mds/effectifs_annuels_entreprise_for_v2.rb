class GIPMDS::EffectifsAnnuelsEntrepriseForV2 < RetrieverOrganizer
  before do
    context.params[:nature] = :yearly
  end

  organize GIPMDS::EffectifsAnnuelsEntreprise::ValidateParams,
    GIPMDS::Authenticate,
    GIPMDS::Effectifs::MakeRequest,
    GIPMDS::Effectifs::ValidateResponseForV2,
    GIPMDS::EffectifsAnnuelsEntreprise::BuildResource

  def provider_name
    'GIP-MDS'
  end
end

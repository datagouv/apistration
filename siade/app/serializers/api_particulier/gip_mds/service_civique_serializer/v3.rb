class APIParticulier::GIPMDS::ServiceCiviqueSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attribute :statut_actuel, if: -> { scope?(:gip_mds_service_civique_statut_actuel) } do
    build_statut(data.statut_actuel)
  end

  attribute :statut_passe, if: -> { scope?(:gip_mds_service_civique_statut_passe) } do
    build_statut(data.statut_passe)
  end

  private

  def build_statut(statut)
    result = { contrat_trouve: statut[:contrat_trouve] }
    result[:organisme_accueil] = statut[:organisme_accueil] if scope?(:gip_mds_service_civique_organisme_accueil)
    if scope?(:gip_mds_service_civique_dates)
      result[:date_debut_contrat] = statut[:date_debut_contrat]
      result[:date_fin_contrat] = statut[:date_fin_contrat]
    end
    result
  end
end

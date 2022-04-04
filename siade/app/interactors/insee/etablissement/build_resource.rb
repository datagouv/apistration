class INSEE::Etablissement::BuildResource < INSEE::BuildResource
  protected

  def resource_attributes
    {
      id: etablissement['siret'],
      siren: etablissement['siren'],
      siege_social: etablissement['etablissementSiege'],
      etat_administratif:,
      date_fermeture:,

      activite_principale: referential(
        'activite_principale',
        code: latest_info_on_etablissement['activitePrincipaleEtablissement'],
        nomenclature: latest_info_on_etablissement['nomenclatureActivitePrincipaleEtablissement']
      ),

      tranche_effectif_salarie: referential(
        'tranche_effectif_salarie',
        code: etablissement['trancheEffectifsEtablissement'],
        date_reference: etablissement['anneeEffectifsEtablissement']
      ),

      diffusable_commercialement: yes_no_to_boolean(etablissement['statutDiffusionEtablissement']),
      date_creation: date_to_timestamp(etablissement['dateCreationEtablissement']),
      date_derniere_mise_a_jour: date_to_timestamp(etablissement['dateDernierTraitementEtablissement'])
    }
  end

  def etablissement
    @etablissement ||= json_body['etablissement']
  end

  private

  def latest_info_on_etablissement
    @latest_info_on_etablissement ||= etablissement['periodesEtablissement'].find do |periode_etablissement|
      periode_etablissement['dateFin'].nil?
    end
  end

  def date_fermeture
    return if etablissement_active?

    date_to_timestamp(periode_with_fermeture_status['dateDebut'])
  end

  def etablissement_active?
    etat_administratif == 'A'
  end

  def etat_administratif
    latest_info_on_etablissement['etatAdministratifEtablissement']
  end

  def periode_with_fermeture_status
    etablissement['periodesEtablissement'].find do |periode|
      periode['changementEtatAdministratifEtablissement']
    end
  end
end

class INSEE::Etablissement::BuildResource < INSEE::BuildResource
  protected

  def resource_attributes
    {
      siret: etablissement['siret'],
      siren: etablissement['siren'],

      unite_legale:,

      siege_social: etablissement['etablissementSiege'],
      etat_administratif:,
      date_fermeture:,

      enseigne: build_enseigne,

      activite_principale: activite_principale_naf2025.to_h,
      activite_principale_naf_rev2: activite_principale_naf_rev2.to_h,

      tranche_effectif_salarie: referential(
        'tranche_effectif_salarie',
        code: etablissement['trancheEffectifsEtablissement'],
        date_reference: etablissement['anneeEffectifsEtablissement']
      ),

      adresse:,

      diffusable_commercialement: diffusable_commercialement(etablissement['statutDiffusionEtablissement']),
      status_diffusion: STATUT_DIFFUSION[etablissement['statutDiffusionEtablissement']],
      type: unite_legale.type,

      date_creation: date_to_timestamp(etablissement['dateCreationEtablissement']),
      date_derniere_mise_a_jour: date_to_timestamp(etablissement['dateDernierTraitementEtablissement']),

      redirect_from_siret: context.redirect_from_siret
    }
  end

  def etablissement
    @etablissement ||= json_body['etablissement'] || json_body['etablissements'][0]
  end

  private

  def adresse
    @adresse ||= INSEE::AdresseEtablissement::BuildResource.call(response: context.response, etablissement:).bundled_data.data
  end

  def unite_legale
    @unite_legale ||= INSEE::UniteLegale::BuildResource.call(response: context.response, unite_legale: etablissement['uniteLegale']).bundled_data.data
  end

  def latest_info_on_etablissement
    @latest_info_on_etablissement ||= etablissement['periodesEtablissement'].find do |periode_etablissement|
      periode_etablissement['dateFin'].nil?
    end
  end

  def build_enseigne
    enseigne_parts = latest_info_on_etablissement.slice('enseigne1Etablissement', 'enseigne2Etablissement', 'enseigne3Etablissement').values

    return unless enseigne_parts.any?

    enseigne_parts.compact.join(', ')
  end

  def date_fermeture
    return if etablissement_active?
    return if date_fermeture_is_missing?

    date_to_timestamp(periode_with_fermeture_status['dateDebut'])
  end

  def date_fermeture_is_missing?
    periode_with_fermeture_status.blank?
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

  def activite_principale_naf2025
    @activite_principale_naf2025 ||= Referentials::ActivitePrincipale.new(
      code: etablissement['activitePrincipaleNAF25Etablissement'],
      nomenclature: 'NAF2025'
    )
  end

  def activite_principale_naf_rev2
    @activite_principale_naf_rev2 ||= Referentials::ActivitePrincipale.new(
      code: latest_info_on_etablissement['activitePrincipaleEtablissement'],
      nomenclature: 'NAFRev2'
    )
  end
end

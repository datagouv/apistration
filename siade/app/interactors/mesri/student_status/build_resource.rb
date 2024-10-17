class MESRI::StudentStatus::BuildResource < BuildResource
  REGIME_FORMATION_INITIALE = 'formation initiale'.freeze
  REGIME_FORMATION_INITIALE_HORS_APPRENTISSAGE = 'formation initiale hors apprentissage'.freeze
  REGIME_REPRISE_ETUDES_NON_FINANCEE_SANS_CONVENTION = 'reprise d\'études non financée sans convention'.freeze
  REGIME_CONTRAT_APPRENTISSAGE = 'contrat d\'apprentissage'.freeze
  REGIME_FORMATION_CONTINUE = 'formation continue'.freeze
  REGIME_FORMATION_CONTINUE_HORS_CONTRAT_PROFESSIONNEL = 'formation continue hors contrat professionnel'.freeze
  REGIME_CONTRAT_PROFESSIONNALISATION = 'contrat de professionnalisation'.freeze

  REGIME_TO_CODE_FORMATION = {
    REGIME_FORMATION_INITIALE => 'RF1',
    REGIME_FORMATION_INITIALE_HORS_APPRENTISSAGE => 'RF2',
    REGIME_REPRISE_ETUDES_NON_FINANCEE_SANS_CONVENTION => 'RF3',
    REGIME_CONTRAT_APPRENTISSAGE => 'RF4',
    REGIME_FORMATION_CONTINUE => 'RF5',
    REGIME_FORMATION_CONTINUE_HORS_CONTRAT_PROFESSIONNEL => 'RF6',
    REGIME_CONTRAT_PROFESSIONNALISATION => 'RF7'
  }.freeze

  def resource_attributes
    {
      ine: json_body['ine'],
      identite: {
        nom_naissance: json_body['nomFamille'],
        prenom: json_body['prenom'],
        date_naissance: json_body['dateNaissance']
      },
      admissions: build_admissions
    }
  end

  private

  def build_admissions
    (json_body['inscriptions'] || []).map do |inscription_payload|
      build_admission(inscription_payload)
    end
  end

  def build_admission(inscription_payload)
    {
      date_debut: format_date(inscription_payload['dateDebutInscription']),
      date_fin: format_date(inscription_payload['dateFinInscription']),
      est_inscrit: inscription_payload['statut'] == 'inscrit',
      regime_formation: inscription_payload['regime'],
      code_formation: REGIME_TO_CODE_FORMATION[inscription_payload['regime']],
      code_cog_insee_commune: inscription_payload['codeCommune'],
      etablissement_etudes: {
        uai: inscription_payload['etablissement']['uai'],
        nom: inscription_payload['etablissement']['nomEtablissement']
      }
    }
  end

  def format_date(date)
    if date.blank?
      date
    else
      Date.parse(date).to_s
    end
  end
end

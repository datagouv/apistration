class APIParticulier::MESRI::StudentStatus::V2 < APIParticulier::V2BaseSerializer
  attribute :ine, if: -> { scope?(:mesri_identifiant) }

  %i[
    nom
    prenom
    dateNaissance
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:mesri_identite) }
  end

  attribute :nom, if: -> { scope?(:mesri_identite) } do
    object.identite[:nom_naissance]
  end

  attribute :prenom, if: -> { scope?(:mesri_identite) } do
    object.identite[:prenom]
  end

  attribute :dateNaissance, if: -> { scope?(:mesri_identite) } do
    object.identite[:date_naissance]
  end

  attribute :inscriptions, if: -> { one_of_scopes?(%i[mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements]) }

  def inscriptions
    object.admissions.map do |initial_inscription|
      final_inscription = {}

      handle_inscription_etudiant_scope!(initial_inscription, final_inscription)
      handle_inscription_autre_scope!(initial_inscription, final_inscription)
      handle_admission_scope!(initial_inscription, final_inscription)

      if final_inscription.present? && scope?(:mesri_etablissements)
        final_inscription.merge!(
          etablissement: initial_inscription[:etablissement],
          codeCommune: initial_inscription[:codeCommune]
        )
      end

      final_inscription
    end
  end

  private

  def handle_inscription_etudiant_scope!(initial_inscription, final_inscription)
    return unless scope?(:mesri_inscription_etudiant) && initial_inscription[:est_inscrit] == true && formation_initiale_regime.include?(initial_inscription[:regime_formation][:libelle])

    final_inscription.merge!(
      statut: 'inscrit',
      regime: 'formation initiale',
      dateDebutInscription: initial_inscription[:date_debut],
      dateFinInscription: initial_inscription[:date_fin]
    )
  end

  def handle_inscription_autre_scope!(initial_inscription, final_inscription)
    return unless scope?(:mesri_inscription_autre) && initial_inscription[:est_inscrit] == true && formation_continue_regime.include?(initial_inscription[:regime_formation][:libelle])

    final_inscription.merge!(
      statut: 'inscrit',
      regime: 'formation continue',
      dateDebutInscription: initial_inscription[:date_debut],
      dateFinInscription: initial_inscription[:date_fin]
    )
  end

  def handle_admission_scope!(initial_inscription, final_inscription)
    return unless scope?(:mesri_admission) && initial_inscription[:est_inscrit] == false

    final_inscription.merge!(
      statut: 'admis',
      regime: initial_inscription[:regime_formation][:libelle],
      dateDebutAdmission: initial_inscription[:date_debut],
      dateFinAdmission: initial_inscription[:date_fin]
    )
  end

  def formation_initiale_regime
    [
      'formation initiale',
      'formation initiale hors apprentissage',
      'reprise d\'études non financée sans convention',
      'contrat d\'apprentissage'
    ]
  end

  def formation_continue_regime
    [
      'formation continue',
      'formation continue hors contrat professionnel',
      'contrat de professionnalisation'
    ]
  end
end

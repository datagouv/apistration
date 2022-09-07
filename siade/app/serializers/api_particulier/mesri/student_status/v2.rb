class APIParticulier::MESRI::StudentStatus::V2 < APIParticulier::V2BaseSerializer
  attribute :ine, if: -> { scope?(:mesri_identifiant) }

  %i[
    nom
    prenom
    dateNaissance
  ].each do |resource_attribute|
    attribute resource_attribute, if: -> { scope?(:mesri_identite) }
  end

  attribute :inscriptions, if: -> { one_of_scopes?(%i[mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements]) }

  def inscriptions
    object.inscriptions.map do |initial_inscription|
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
    return unless scope?(:mesri_inscription_etudiant) && initial_inscription[:statut] == 'inscrit' && initial_inscription[:regime] == 'formation initiale'

    final_inscription.merge!(
      statut: 'inscrit',
      regime: 'formation initiale',
      dateDebutInscription: format_date(initial_inscription[:dateDebutInscription]),
      dateFinInscription: format_date(initial_inscription[:dateFinInscription])
    )
  end

  def handle_inscription_autre_scope!(initial_inscription, final_inscription)
    return unless scope?(:mesri_inscription_autre) && initial_inscription[:statut] == 'inscrit' && initial_inscription[:regime] == 'formation continue'

    final_inscription.merge!(
      statut: 'inscrit',
      regime: 'formation continue',
      dateDebutInscription: format_date(initial_inscription[:dateDebutInscription]),
      dateFinInscription: format_date(initial_inscription[:dateFinInscription])
    )
  end

  def handle_admission_scope!(initial_inscription, final_inscription)
    return unless scope?(:mesri_admission) && initial_inscription[:statut] == 'admis'

    final_inscription.merge!(
      statut: 'admis',
      regime: initial_inscription[:regime],
      dateDebutAdmission: format_date(initial_inscription[:dateDebutInscription]),
      dateFinAdmission: format_date(initial_inscription[:dateFinInscription])
    )
  end

  def format_date(date)
    if date.blank?
      date
    else
      Date.parse(date).to_s
    end
  end
end

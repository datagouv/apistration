class APIParticulier::MESRI::StatutEtudiantSerializer::AttestationProofBuilder < APIParticulier::AttestationProofBuilder
  INSCRIPTION_LABELS = { true => 'Inscrit', false => 'Admis, non inscrit' }.freeze

  IDENTITE = [
    ['nom_naissance', 'Nom de naissance'],
    ['prenom', 'Prénom'],
    ['date_naissance', 'Date de naissance']
  ].freeze

  ADMISSION = [
    ['date_debut', "Début de la période d'études"],
    ['date_fin', "Fin de la période d'études"],
    ['est_inscrit', "État de l'inscription"],
    ['regime_formation', 'Régime de formation'],
    ['code_cog_insee_commune', "Code INSEE de la commune d'études"],
    ['etablissement_nom', "Établissement d'études"],
    ['etablissement_uai', "Code UAI de l'établissement"]
  ].freeze

  ADMISSIONS_RESUME = [
    ['nombre', "Nombre d'admissions"],
    ['nombre_inscriptions', 'Dont inscriptions'],
    ['periode', "Période d'études couverte"],
    ['dernier_etablissement', "Dernier établissement d'études"]
  ].freeze

  protected

  def document
    'statut_etudiant'
  end

  def title
    'ATTESTATION DE STATUT ÉTUDIANT'
  end

  def verification_sections
    [etudiant_section(IDENTITE_MINIMISEE), admissions_resume_section].compact
  end

  def attestation_sections
    [etudiant_section(IDENTITE), admissions_section].compact
  end

  private

  def admissions
    @admissions ||= data['admissions'] || []
  end

  def etudiant_section(table)
    section('Étudiant') { [rows(table, data['identite'] || {})] }
  end

  def admissions_section
    section('Admissions') do
      admissions.map { |admission| rows(ADMISSION, admission_entry(admission)) }
    end
  end

  def admission_entry(admission)
    admission.merge(
      'est_inscrit' => INSCRIPTION_LABELS[admission['est_inscrit']],
      'regime_formation' => admission.dig('regime_formation', 'libelle'),
      'etablissement_nom' => admission.dig('etablissement_etudes', 'nom'),
      'etablissement_uai' => admission.dig('etablissement_etudes', 'uai')
    )
  end

  def admissions_resume_section
    section('Admissions') do
      [rows(ADMISSIONS_RESUME, admissions_resume)] if admissions.any?
    end
  end

  # Un résumé n'atteste que ce que le fournisseur a dit de toutes les
  # admissions : une donnée absente d'une seule d'entre elles — champ hors
  # habilitation, date manquante — retire la ligne, plutôt que de signer un
  # compte ou une période fausse pour cinq ans.
  def admissions_resume
    {
      'nombre' => admissions.size,
      'nombre_inscriptions' => nombre_inscriptions,
      'periode' => periode_etudes,
      'dernier_etablissement' => dernier_etablissement
    }
  end

  def nombre_inscriptions
    return unless admissions.all? { |admission| admission.key?('est_inscrit') }

    admissions.count { |admission| admission['est_inscrit'] }
  end

  def periode_etudes
    return unless toutes_datees?('date_debut') && toutes_datees?('date_fin')

    "#{format_date(dates('date_debut').min)} – #{format_date(dates('date_fin').max)}"
  end

  def dernier_etablissement
    return unless toutes_datees?('date_debut')

    admissions.max_by { |admission| admission['date_debut'] }.dig('etablissement_etudes', 'nom')
  end

  def toutes_datees?(key)
    dates(key).all?(&:present?)
  end

  def dates(key)
    admissions.pluck(key)
  end
end

class CNAV::ParticipationFamilialeEAJE::BuildNotFoundAttestationProof < APIParticulier::BuildAttestationProof
  SEXE_LABELS = CNAV::ParticipationFamilialeEAJE::BuildAttestationProof::SEXE_LABELS

  IDENTITE = [
    ['nom_naissance', 'Nom de naissance'],
    ['nom_usage', "Nom d'usage"],
    ['prenoms', 'Prénoms', ->(prenoms) { Array(prenoms).join(' ') }],
    ['date_naissance', 'Date de naissance'],
    ['sexe_etat_civil', 'Sexe', ->(sexe) { SEXE_LABELS.fetch(sexe, sexe) }],
    ['code_cog_insee_commune_naissance', 'Code INSEE de la commune de naissance'],
    ['nom_commune_naissance', 'Commune de naissance'],
    ['code_cog_insee_departement_naissance', 'Département de naissance'],
    ['code_cog_insee_pays_naissance', 'Code INSEE du pays de naissance']
  ].freeze

  protected

  def document
    'participation_familiale_eaje'
  end

  def title
    'ATTESTATION DE CONSULTATION SANS RÉSULTAT (PARTICIPATION FAMILIALE EAJE)'
  end

  def source
    not_found_error['origin']
  end

  def verification_sections
    [result_section, identity_section(CNAV::ParticipationFamilialeEAJE::BuildAttestationProof::IDENTITE_MINIMISEE)]
  end

  def attestation_sections
    [result_section, identity_section(IDENTITE)]
  end

  private

  def mocked_error?
    false
  end

  def result_section
    {
      'titre' => 'Résultat de la consultation',
      'entrees' => [[
        ['Résultat', not_found_error['title']],
        ['Détail', not_found_error['detail']],
        ['Origine', not_found_error['origin']],
        ['Consultation effectuée le', consulted_at]
      ]]
    }
  end

  def identity_section(table)
    { 'titre' => "Identité de l'usager transmise lors de l'appel", 'entrees' => [rows(table, identity)] }
  end

  def not_found_error
    context.not_found_error
  end

  def identity
    @identity ||= build_identity
  end

  def build_identity
    identity_params.merge('date_naissance' => date_naissance)
  end

  def identity_params
    @identity_params ||= context.params.to_h.stringify_keys
  end

  def date_naissance
    Civility::FormatDateNaissance.new(*identity_params.values_at('annee_date_naissance', 'mois_date_naissance', 'jour_date_naissance')).format
  end

  def consulted_at
    called_at.strftime('%d/%m/%Y à %H:%M')
  end

  def called_at
    @called_at ||= Time.zone.now
  end
end

class CNAV::ParticipationFamilialeEAJE::BuildAttestationProof < APIParticulier::BuildAttestationProof
  SEXE_LABELS = { 'M' => 'Masculin', 'F' => 'Féminin' }.freeze

  IDENTITE = [
    ['nom_naissance', 'Nom de naissance'],
    ['nom_usage', "Nom d'usage"],
    ['prenoms', 'Prénoms'],
    ['date_naissance', 'Date de naissance'],
    ['sexe', 'Sexe', ->(sexe) { SEXE_LABELS.fetch(sexe, sexe) }],
    ['code_cog_insee_commune_naissance', 'Code INSEE de la commune de naissance']
  ].freeze

  IDENTITE_MINIMISEE = [
    ['nom_naissance', 'Nom de naissance', ->(nom) { "#{nom.first(3)}•••" }],
    ['date_naissance', 'Date de naissance', ->(date) { "#{date[5, 2]}/#{date[0, 4]}" }]
  ].freeze

  ADRESSE = [
    ['destinataire', 'Destinataire'],
    ['complement_information', "Complément d'information"],
    ['complement_information_geographique', "Complément d'information géographique"],
    ['numero_libelle_voie', 'Numéro et libellé de voie'],
    ['lieu_dit', 'Lieu-dit'],
    ['code_postal_ville', 'Code postal / Ville'],
    ['pays', 'Pays']
  ].freeze

  PARAMETRES = [
    ['nombre_enfants_a_charge', "Nombre d'enfants à charge"],
    ['nombre_enfants_beneficiaire_aeeh', "Nombre d'enfants bénéficiaires de l'AEEH"]
  ].freeze

  BASE_RESSOURCES = [
    ['valeur', 'Base de ressources annuelles', ->(valeur) { { 'highlight' => display(valeur) } }],
    ['annee_calcul', 'Année de calcul']
  ].freeze

  IDENTITE_TRANSMISE = (IDENTITE + [
    ['code_cog_insee_departement_naissance', 'Code INSEE du département de naissance'],
    ['code_cog_insee_pays_naissance', 'Code INSEE du pays de naissance'],
    ['nom_commune_naissance', 'Nom de la commune de naissance']
  ]).freeze

  IDENTITE_TRANSMISE_MINIMISEE = [
    IDENTITE_MINIMISEE.first,
    ['mois_annee_naissance', 'Date de naissance']
  ].freeze

  protected

  def attestable?
    super || no_result.present?
  end

  def document
    'participation_familiale_eaje'
  end

  def title
    return 'ATTESTATION DE CONSULTATION SANS RÉSULTAT' if no_result

    'ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)'
  end

  def source
    return no_result[:origin] if no_result

    'CNAF'
  end

  def verification_sections
    return no_result_sections(IDENTITE_TRANSMISE_MINIMISEE) if no_result

    [
      allocataires_section(IDENTITE_MINIMISEE),
      section('Enfants', 'cnav_participation_familiale_eaje_enfants') do
        [[["Nombre d'enfants", data['enfants'].size.to_s]]] if data['enfants'].present?
      end,
      parametres_section
    ].compact
  end

  def attestation_sections
    return no_result_sections(IDENTITE_TRANSMISE) if no_result

    [
      allocataires_section(IDENTITE),
      section('Enfants', 'cnav_participation_familiale_eaje_enfants') do
        data['enfants']&.map { |enfant| rows(IDENTITE, enfant) }
      end,
      section('Adresse', 'cnav_participation_familiale_eaje_adresse') { [rows(ADRESSE, data['adresse'] || {})] },
      parametres_section
    ].compact
  end

  private

  def no_result
    @no_result ||= context.mocked_data.present? ? mocked_no_result : context.no_result
  end

  def mocked_no_result
    return unless context.mocked_data[:status] == 404

    error = context.mocked_data[:payload]['errors'].first

    {
      error: NotFoundError.new(error['meta']['provider'], error['detail'], title: error['title'], with_identifiant_message: false),
      origin: mocked_origin(error)
    }
  end

  def mocked_origin(error)
    return 'RNCPS' if error['title'] == CNAV::ValidateResponse::ALLOCATAIRE_NOT_REFERENCED.options[:title]

    error['meta']['provider']
  end

  def no_result_sections(identite)
    [
      { 'titre' => 'Résultat de la consultation', 'entrees' => [resultat_consultation] },
      { 'titre' => "Identité de l'usager transmise lors de l'appel", 'entrees' => [rows(identite, identite_transmise)] }
    ]
  end

  def resultat_consultation
    [
      ['Erreur', no_result[:error].title],
      ['Détail', no_result[:error].detail],
      ['Origine', no_result[:origin]],
      ["Date et heure de l'appel", appele_le]
    ]
  end

  def appele_le
    @appele_le ||= Time.current.in_time_zone('Europe/Paris').strftime('%d/%m/%Y à %H:%M')
  end

  def identite_transmise
    params = context.params.to_h.stringify_keys

    params.merge(
      'prenoms' => Array(params['prenoms']).join(' '),
      'date_naissance' => date_parts(*params.values_at('jour_date_naissance', 'mois_date_naissance', 'annee_date_naissance')),
      'mois_annee_naissance' => date_parts(*params.values_at('mois_date_naissance', 'annee_date_naissance')),
      'sexe' => params['sexe_etat_civil']
    )
  end

  def date_parts(*parts)
    parts.compact_blank.map { |part| part.to_s.rjust(2, '0') }.join('/')
  end

  def allocataires_section(table)
    section('Allocataires', 'cnav_participation_familiale_eaje_allocataires') do
      data['allocataires']&.map { |allocataire| rows(table, allocataire) }
    end
  end

  def parametres_section
    @parametres_section ||=
      section('Paramètres de calcul de la participation familiale', 'cnav_participation_familiale_eaje_parametres_calcul') do
        parametres = data['parametres_calcul_participation_familiale'] || {}

        [rows(PARAMETRES, parametres) + rows(BASE_RESSOURCES, parametres['base_ressources_annuelles'] || {})]
      end
  end
end

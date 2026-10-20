class APIParticulier::NoResultAttestationProofBuilder < APIParticulier::AttestationProofBuilder
  TITLES = {
    no_result: 'ATTESTATION DE CONSULTATION SANS RÉSULTAT',
    not_eligible: 'ATTESTATION DE CONSULTATION : DOSSIER NON ÉLIGIBLE'
  }.freeze

  RESULTAT = [
    ['title', 'Erreur'],
    ['detail', 'Détail'],
    ['origin', 'Origine'],
    ['appel_le', "Date et heure de l'appel"]
  ].freeze

  IDENTITE_TRANSMISE = [
    ['nom_naissance', 'Nom de naissance'],
    ['nom_usage', "Nom d'usage"],
    ['prenoms', 'Prénoms'],
    ['date_naissance', 'Date de naissance'],
    ['sexe', 'Sexe', ->(sexe) { SEXE_LABELS.fetch(sexe, sexe) }],
    ['code_cog_insee_pays_naissance', 'Code INSEE du pays de naissance'],
    ['code_cog_insee_commune_naissance', 'Code INSEE de la commune de naissance'],
    ['nom_commune_naissance', 'Commune de naissance'],
    ['code_cog_insee_departement_naissance', 'Code INSEE du département de naissance']
  ].freeze

  def initialize(body, attestation:, request_params:, **)
    super(body, **)
    @attestation = attestation
    @request_params = request_params
  end

  protected

  def document
    'consultation'
  end

  def title
    TITLES.fetch(@attestation)
  end

  def source
    origin
  end

  def verification_sections
    [resultat_section, identite_transmise_section(IDENTITE_MINIMISEE)].compact
  end

  def attestation_sections
    [resultat_section, identite_transmise_section(IDENTITE_TRANSMISE)].compact
  end

  private

  def error
    @body.fetch('errors').first
  end

  def origin
    error.dig('meta', 'origin') || ORIGINE_NON_COMMUNIQUEE
  end

  def resultat_section
    section('Résultat de la consultation') { [rows(RESULTAT, resultat)] }
  end

  def resultat
    error.merge('origin' => origin, 'appel_le' => appel_le)
  end

  def appel_le
    @appel_le ||= Time.zone.now.strftime('%d/%m/%Y à %H:%M:%S')
  end

  def identite_transmise_section(table)
    section("Identité de l'usager transmise lors de l'appel") { [rows(table, identite_transmise)] }
  end

  def identite_transmise
    @identite_transmise ||= build_identite_transmise
  end

  def build_identite_transmise
    @request_params.to_h.stringify_keys.merge(
      'prenoms' => Array(@request_params[:prenoms]).join(' '),
      'date_naissance' => date_naissance_transmise,
      'sexe' => @request_params[:sexe_etat_civil]
    )
  end

  def date_naissance_transmise
    return if @request_params[:annee_date_naissance].blank?

    Civility::FormatDateNaissance.new(
      @request_params[:annee_date_naissance],
      @request_params[:mois_date_naissance],
      @request_params[:jour_date_naissance]
    ).format
  end
end

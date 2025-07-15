class INPI::RNE::ExtraitRNE::BuildResource < BuildResource
  include Rails.application.routes.url_helpers
  ROLE_MAPPING = {
    '40' => 'PRESIDENT',
    '41' => 'DIRECTEUR GENERAL',
    '73' => 'Président',
    '6000' => 'Président',
    '6001' => 'Président du conseil d\'administration',
    '6002' => 'Président du conseil de surveillance',
    '6100' => 'Directeur Général',
    '6101' => 'Directeur Général Délégué',
    '6200' => 'Gérant',
    '6300' => 'Administrateur',
    '6400' => 'Membre du conseil de surveillance',
    '30' => 'Commissaire aux comptes titulaire',
    '31' => 'Commissaire aux comptes suppléant',
    '67' => 'Associé'
  }.freeze

  FORME_JURIDIQUE_MAPPING = {
    '5498' => 'SARL',
    '5510' => 'Société anonyme à conseil d\'administration',
    '5710' => 'SAS, société par actions simplifiée',
    '5720' => 'SASU, société par actions simplifiée unipersonnelle',
    '6540' => 'EURL',
    '1000' => 'Entreprise individuelle'
  }.freeze

  STATUT_ETABLISSEMENT = {
    '5' => 'actif',
    '6' => 'fermé'
  }.freeze

  ORIGINE_FONDS_MAPPING = {
    '2' => 'Achat',
    '3' => 'Apport',
    '4' => 'Donation'
  }.freeze

  DATE_FORMATTERS = {
    iso: lambda { |date|
      return nil if date.blank?

      if date.include?('T')
        DateTime.parse(date).strftime('%Y-%m-%d')
      else
        Date.parse(date).strftime('%Y-%m-%d')
      end
    },
    naissance: lambda { |date|
      return nil if date.blank?

      date.gsub(/^(\d{4})-(\d{2})$/, '\2/\1')
    },
    cloture: lambda { |date|
      return nil if date.blank?

      if date =~ /^(\d{2})(\d{2})$/
        "#{::Regexp.last_match(2)}/#{::Regexp.last_match(1)}"
      elsif date =~ /^(\d{4})$/
        "#{date[0..1]}/#{date[2..3]}"
      else
        date
      end
    }
  }.freeze

  DEFAULT_DEVISE = 'EUR'.freeze
  DEFAULT_PAYS = 'FRANCE'.freeze
  STATUT_FERME = '6'.freeze
  TYPE_PERSONNE_PHYSIQUE = 'P'.freeze
  TYPE_PERSONNE_MORALE = 'MORALE'.freeze
  DIFFUSION_INSEE_OUI = 'O'.freeze
  STATUT_ACTIF = 'actif'.freeze
  TYPE_ETABLISSEMENT_PRINCIPAL = 'Siège et principal'.freeze
  TYPE_ETABLISSEMENT_SECONDAIRE = 'Secondaire'.freeze
  ORIGINE_FONDS_DEFAULT = 'Création'.freeze
  FOURNISSEUR_RCS = 'rcs'.freeze
  FOURNISSEUR_RNM = 'rnm'.freeze
  ENCODING_UTF8 = 'UTF-8'.freeze
  ENCODING_ISO = 'ISO-8859-1'.freeze
  PRODUCTION_HOST = 'entreprise.api.gouv.fr'.freeze

  protected

  def resource_attributes
    {
      document_url: link(target: 'extrait', document_id: siren),
      identite_entreprise: extract_entreprise,
      dirigeants_et_associes: extract_dirigeants,
      etablissements: extract_etablissements_actifs,
      diffusion_commerciale: formality['diffusionCommerciale'] || false,
      diffusion_insee: formality['diffusionINSEE'] == DIFFUSION_INSEE_OUI || false,
      etablissements_fermes_total: count_etablissements_fermes,
      observations: extract_observations
    }
  end

  private

  # Data accessor methods
  def formality
    @formality ||= json_body['formality'] || {}
  end

  def content
    @content ||= formality['content'] || {}
  end

  def personne
    @personne ||= personne_morale.presence || personne_physique
  end

  def personne_morale
    @personne_morale ||= content['personneMorale'] || {}
  end

  def personne_physique
    @personne_physique ||= content['personnePhysique'] || {}
  end

  def siren
    formality['siren'] || json_body['siren']
  end

  def entreprise_data
    @entreprise_data ||= personne.dig('identite', 'entreprise') || {}
  end

  def composition
    @composition ||= personne['composition'] || {}
  end

  def pouvoirs
    @pouvoirs ||= composition['pouvoirs'] || []
  end

  def commissaires_data
    @commissaires_data ||= composition['commissairesAuxComptes'] || []
  end

  def beneficiaires_data
    @beneficiaires_data ||= personne['beneficiairesEffectifs'] || []
  end

  def nature_creation
    @nature_creation ||= content['natureCreation'] || {}
  end

  def identite
    @identite ||= personne['identite'] || {}
  end

  def description
    @description ||= identite['description'] || {}
  end

  # Helper methods for data extraction

  def extract_if_personne_present(default_value = [])
    return default_value if personne.blank?

    yield
  end

  def extract_entities(collection_method, &)
    extract_if_personne_present([]) do
      send(collection_method).filter_map(&)
    end
  end

  def build_person_base(person_data, additional_fields = {})
    description = safe_get(person_data, 'descriptionPersonne')
    base = build_person_identity_hash(description)
    base.merge(additional_fields)
  end

  def build_person_identity_hash(description)
    {
      nom: description['nom'],
      prenom: description.dig('prenoms', 0),
      date_naissance: format_date_naissance(description['dateDeNaissance'])
    }
  end

  # Entreprise extraction methods

  def extract_entreprise
    extract_if_personne_present({}) { build_entreprise_hash }
  end

  def build_entreprise_hash
    base_hash = build_entreprise_base_hash
    dates_hash = build_entreprise_dates_hash
    additional_hash = build_entreprise_additional_hash

    base_hash.merge(dates_hash).merge(additional_hash)
  end

  def build_entreprise_base_hash
    {
      siren: siren,
      denomination: entreprise_data['denomination'],
      forme_juridique: build_forme_juridique_hash_from_data,
      nature_entreprise: content['formeExerciceActivitePrincipale'],
      associe_unique: entreprise_data['indicateurAssocieUnique'] || false
    }
  end

  def build_entreprise_dates_hash
    {
      date_immatriculation_rne: build_date_immatriculation,
      date_debut_activite: format_date(entreprise_data['dateDebutActiv']),
      date_fin_personne: format_date(description['dateFinExistence']),
      date_cloture_exercice: format_date_cloture(description['dateClotureExerciceSocial']),
      date_premiere_cloture_exercice: format_date(description['datePremiereCloture']),
      detail_cessation: nil,
      dissolution: build_dissolution_hash
    }
  end

  def build_dissolution_hash
    {
      date: format_date(description['dateDissolutionDisparition']),
      poursuite_activite: description['indicateurPoursuiteActivite'] || false,
      avec_liquidation: nil
    }
  end

  def detail_cessation_entreprise
    personne['detailCessationEntreprise'] || {}
  end

  # Code hash builders

  def build_entreprise_additional_hash
    {
      capital_social: build_capital_social_hash,
      activite_principales_objet_social: description['objet'],
      code_APE: build_code_ape_hash,
      code_APRM: build_code_aprm_hash,
      adresse_siege_social: extract_adresse_siege(personne)
    }
  end

  def build_forme_juridique_hash_from_data
    forme_juridique_code = entreprise_data['formeJuridique'] || nature_creation['formeJuridique']
    build_forme_juridique_hash(forme_juridique_code)
  end

  def build_date_immatriculation
    format_date(entreprise_data['dateImmat'] || nature_creation['dateCreation'])
  end

  def build_forme_juridique_hash(forme_juridique_code)
    {
      code: forme_juridique_code,
      libelle: get_forme_juridique_libelle(forme_juridique_code)
    }
  end

  def build_capital_social_hash
    {
      montant: description['montantCapital'],
      devise: description['deviseCapital'] || DEFAULT_DEVISE
    }
  end

  def build_code_ape_hash
    build_code_hash(entreprise_data['codeApe'], :activite)
  end

  def build_code_aprm_hash
    return { code: nil, libelle: nil } unless entreprise_data['codeAprm']

    build_code_hash(entreprise_data['codeAprm'], :aprm)
  end

  def extract_adresse_siege(personne)
    adresse_entreprise = safe_get(personne, 'adresseEntreprise')
    adresse = safe_get(adresse_entreprise, 'adresse')

    format_adresse(adresse)
  end

  def extract_dirigeants
    extract_entities(:pouvoirs) do |pouvoir|
      next unless pouvoir_actif_et_individu?(pouvoir)

      build_dirigeant(pouvoir)
    end
  end

  def pouvoir_actif_et_individu?(pouvoir)
    pouvoir['actif'] != false &&
      pouvoir['typeDePersonne'] == TYPE_PERSONNE_PHYSIQUE &&
      pouvoir['individu']
  end

  def build_dirigeant(pouvoir)
    individu = pouvoir['individu']
    role_entreprise = safe_get(pouvoir, 'roleEntreprise')
    description = safe_get(individu, 'descriptionPersonne')

    build_person_identity_hash(description).merge(
      qualite: extract_qualite(role_entreprise),
      commune_residence: individu.dig('adresseDomicile', 'commune')
    )
  end

  def extract_qualite(role_entreprise)
    role_code = role_entreprise['rolePersonne']
    ROLE_MAPPING[role_code] || role_entreprise['denomination'] || role_code
  end

  def cac_actif_et_moral?(cac)
    cac['actif'] != false &&
      cac['typeDePersonne'] == TYPE_PERSONNE_MORALE &&
      cac['entreprise']
  end

  # Etablissements extraction methods

  def extract_etablissements_actifs
    extract_if_personne_present([]) do
      [
        process_etablissement_principal,
        *process_autres_etablissements
      ]
    end
  end

  def process_etablissement_principal
    etab = personne['etablissementPrincipal']
    format_etablissement(etab, TYPE_ETABLISSEMENT_PRINCIPAL) if etab && etablissement_actif?(etab)
  end

  def process_autres_etablissements
    (personne['autresEtablissements'] || [])
      .filter_map { |e| format_etablissement(e, TYPE_ETABLISSEMENT_SECONDAIRE) if etablissement_actif?(e) }
  end

  def etablissement_actif?(etab)
    desc = safe_get(etab, 'descriptionEtablissement')
    desc['statutPourFormalite'] != STATUT_FERME && desc['dateEffetFermeture'].nil?
  end

  def format_etablissement(etab, type_default)
    desc = safe_get(etab, 'descriptionEtablissement')
    adresse = safe_get(etab, 'adresse')
    activites = safe_get(etab, 'activites', [])

    build_etablissement_hash(
      desc,
      adresse,
      find_activite_principale(activites),
      find_autres_activites(activites),
      type_default
    )
  end

  def find_activite_principale(activites)
    activites.find { |a| a['indicateurPrincipal'] }
  end

  def find_autres_activites(activites)
    activites.reject { |a| a['indicateurPrincipal'] }
  end

  def build_etablissement_hash(desc, adresse, activite_principale, autres_activites, type_default)
    build_etablissement_base_hash(desc, type_default)
      .merge(build_etablissement_activite_hash(desc, activite_principale, autres_activites))
      .merge(build_etablissement_adresse_hash(adresse))
  end

  def build_etablissement_base_hash(desc, type_default)
    {
      siret: desc['siret'],
      type_etablissement: type_default,
      statut: STATUT_ACTIF
    }
  end

  def build_etablissement_activite_hash(desc, activite_principale, autres_activites)
    {
      date_debut_activite: extract_date_debut_activite(desc, activite_principale),
      code_APE: build_code_ape_hash_from_desc(desc),
      code_APRM: build_code_aprm_hash_from_desc(desc),
      origine_fonds: get_origine_fonds(activite_principale),
      nature_etablissement: activite_principale&.dig('formeExercice'),
      activite_principale: fix_encoding(activite_principale&.dig('descriptionDetaillee')),
      autre_activite: format_autres_activites(autres_activites)
    }
  end

  def build_etablissement_adresse_hash(adresse)
    {
      adresse: format_adresse_etablissement(adresse)
    }
  end

  def extract_date_debut_activite(desc, activite_principale)
    format_date(desc['dateEffet'] || activite_principale&.dig('dateDebut'))
  end

  def build_code_ape_hash_from_desc(desc)
    build_code_hash(desc['codeApe'], :activite)
  end

  def build_code_aprm_hash_from_desc(desc)
    {
      code: desc['codeAprm'],
      libelle: nil
    }
  end

  def format_autres_activites(autres_activites)
    return nil if autres_activites.empty?

    autres_activites.join(', ')
  end

  def build_code_hash(code, type)
    {
      code: code,
      libelle: get_code_libelle(code, type)
    }
  end

  def get_code_libelle(code, type)
    case type
    when :activite
      get_activite_libelle(code)
    when :aprm
      get_code_aprm_libelle(code)
    end
  end

  # Dirigeants extraction methods

  def count_etablissements_fermes
    extract_if_personne_present(0) do
      count_closed_etablissement(personne['etablissementPrincipal']) +
        count_closed_etablissements(personne['autresEtablissements'] || [])
    end
  end

  def count_closed_etablissement(etablissement)
    etablissement_actif?(etablissement) ? 0 : 1
  end

  def count_closed_etablissements(etablissements)
    etablissements.count { |e| !etablissement_actif?(e) }
  end

  # Observations extraction methods

  def extract_observations
    rcs_observations + rnm_observations
  end

  def rcs_observations
    format_rcs_observations(extract_rcs_observations_data)
  end

  def rnm_observations
    format_rnm_observations(content['inscriptionsOffices'] || [])
  end

  def extract_rcs_observations_data
    content.dig('personneMorale', 'observations', 'rcs') || []
  end

  def safe_get(hash, key, default = {})
    return default unless hash

    hash[key] || default
  end

  def format_rnm_observations(observations)
    observations.map do |obs|
      build_observation_hash(FOURNISSEUR_RNM, nil, obs['dateEffet'], obs['observationComplementaire'])
    end
  end

  def format_rcs_observations(observations)
    observations.map do |obs|
      build_observation_hash(FOURNISSEUR_RCS, obs['numObservation'], obs['dateAjout'], fix_encoding(obs['texte']))
    end
  end

  def build_observation_hash(fournisseur, numero, date, texte)
    {
      fournisseur: fournisseur,
      numero: numero,
      date: format_date(date),
      texte: texte
    }
  end

  # Formatting and utility methods

  def format_date(date_string, type: :iso)
    return nil if date_string.blank?

    DATE_FORMATTERS[type].call(date_string)
  rescue StandardError
    date_string
  end

  def format_date_naissance(date_string)
    format_date(date_string, type: :naissance)
  end

  def format_date_cloture(date_string)
    format_date(date_string, type: :cloture)
  end

  def format_adresse(adresse, with_complement: false)
    return nil if adresse.blank?

    build_unified_address(adresse, with_complement)
  end

  def format_adresse_etablissement(adresse)
    format_adresse(adresse, with_complement: true)
  end

  def build_unified_address(adresse, with_complement)
    result = build_base_address_hash(adresse)
    add_complement_field(result, adresse, with_complement)
    result
  end

  def build_base_address_hash(adresse)
    parts = build_address_parts(adresse)
    {
      voie: parts.join(' ').upcase,
      code_postal: adresse['codePostal'],
      commune: adresse['commune']&.upcase,
      pays: adresse['pays'] || DEFAULT_PAYS
    }
  end

  def build_address_parts(adresse)
    [
      adresse['numVoie'],
      adresse['typeVoie'],
      adresse['voie']
    ].compact
  end

  def add_complement_field(result, adresse, _with_complement)
    result[:complement] = adresse['complementLocalisation']
  end

  def get_forme_juridique_libelle(code)
    FORME_JURIDIQUE_MAPPING[code] || "Forme juridique #{code}"
  end

  def get_activite_libelle(code_ape)
    get_code_from_config(:code_ape, code_ape, "Activité #{code_ape}")
  end

  def get_code_aprm_libelle(code_aprm)
    get_code_from_config(:code_aprm, code_aprm, "Activité Art #{code_aprm}")
  end

  def get_code_from_config(config_key, code, fallback)
    config_value = Rails.application.config_for(config_key)[code]
    config_value || fallback
  end

  def get_origine_fonds(activite)
    origine = safe_get(activite, 'origine')
    ORIGINE_FONDS_MAPPING[origine['typeOrigine']] || ORIGINE_FONDS_DEFAULT
  end

  def fix_encoding(text)
    return nil if text.nil?

    begin
      text.force_encoding(ENCODING_UTF8)

      return text.presence if text.valid_encoding?

      converted_text = text.force_encoding(ENCODING_ISO).encode(ENCODING_UTF8)
      converted_text.presence
    rescue Encoding::UndefinedConversionError, Encoding::InvalidByteSequenceError
      text.force_encoding(ENCODING_UTF8).scrub
    end
  end

  def link(target:, document_id:)
    url_for(
      controller: 'api_entreprise/inpi_proxy',
      action: 'show',
      uuid: encrypted_uuid(target:, document_id:),
      host:
    )
  end

  def encrypted_uuid(target:, document_id:)
    StringEncryptorService.instance.encrypt_url_safe(raw_uuid(target:, document_id:))
  end

  def raw_uuid(target:, document_id:)
    {
      target:,
      document_id:,
      timestamp:,
      token_id:
    }.to_json
  end

  def host
    Rails.env.production? ? PRODUCTION_HOST : "#{Rails.env}.#{PRODUCTION_HOST}"
  end

  def timestamp
    Time.zone.now.to_i
  end

  def token_id
    context.params[:token_id]
  end
end

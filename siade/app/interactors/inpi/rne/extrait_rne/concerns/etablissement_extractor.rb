# rubocop:disable Metrics/ModuleLength
module INPI::RNE::ExtraitRNE::Concerns::EtablissementExtractor
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters

  def extract_etablissements
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
      .filter_map { |e| format_etablissement(e, TYPE_ETABLISSEMENT_SECONDAIRE) }
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
      statut: get_etablissement_statut(desc)
    }
  end

  def get_etablissement_statut(desc)
    if desc['statutPourFormalite'] == STATUT_FERME || desc['dateEffetFermeture'].present?
      'fermé'
    else
      STATUT_ACTIF
    end
  end

  def build_etablissement_activite_hash(desc, activite_principale, autres_activites)
    {
      date_debut_activite: extract_date_debut_activite(desc, activite_principale),
      code_APE: build_code_ape_hash_from_desc(desc),
      code_APRM: build_code_aprm_hash_from_activity(activite_principale),
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

  def build_code_aprm_hash_from_activity(activite_principale)
    return { code: nil, libelle: nil } unless activite_principale&.dig('codeAprm')

    build_code_hash(activite_principale['codeAprm'], :aprm)
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

  def format_autres_activites(autres_activites)
    return nil if autres_activites.empty?

    autres_activites.join(', ')
  end

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
end
# rubocop:enable Metrics/ModuleLength

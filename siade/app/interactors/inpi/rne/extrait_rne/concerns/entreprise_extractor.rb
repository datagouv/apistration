# rubocop:disable Metrics/ModuleLength
module INPI::RNE::ExtraitRNE::Concerns::EntrepriseExtractor
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters

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
      nom: extract_entrepreneur_nom,
      prenoms: extract_entrepreneur_prenoms,
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

  def extract_adresse_siege(personne)
    adresse_entreprise = safe_get(personne, 'adresseEntreprise')
    adresse = safe_get(adresse_entreprise, 'adresse')

    format_adresse(adresse)
  end

  def detail_cessation_entreprise
    personne['detailCessationEntreprise'] || {}
  end

  def extract_entrepreneur_nom
    entrepreneur_description['nom']
  end

  def extract_entrepreneur_prenoms
    entrepreneur_description['prenoms']
  end

  def entrepreneur_description
    @entrepreneur_description ||= identite.dig('entrepreneur', 'descriptionPersonne') || {}
  end
end
# rubocop:enable Metrics/ModuleLength

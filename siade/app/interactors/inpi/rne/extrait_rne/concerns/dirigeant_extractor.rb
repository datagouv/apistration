module INPI::RNE::ExtraitRNE::Concerns::DirigeantExtractor
  include INPI::RNE::ExtraitRNE::Concerns::Constants
  include INPI::RNE::ExtraitRNE::Concerns::DataFormatters

  def extract_dirigeants
    extract_entities(:pouvoirs) do |pouvoir|
      next unless pouvoir_actif_et_individu?(pouvoir)

      build_dirigeant(pouvoir)
    end
  end

  def pouvoir_actif_et_individu?(pouvoir)
    pouvoir['actif'] != false &&
      [TYPE_PERSONNE_PHYSIQUE, TYPE_PERSONNE_INDIVIDU].include?(pouvoir['typeDePersonne']) &&
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
    if role_entreprise.is_a?(String)
      get_role_libelle(role_entreprise)
    else
      extract_qualite_from_object(role_entreprise)
    end
  end

  def extract_qualite_from_object(role_entreprise)
    role_code = role_entreprise['rolePersonne']
    libelle = get_role_libelle(role_code)
    return libelle unless libelle == role_code && role_entreprise['denomination']

    role_entreprise['denomination']
  end

  def build_person_identity_hash(description)
    {
      nom: description['nom'],
      prenom: description.dig('prenoms', 0),
      date_naissance: format_date_naissance(description['dateDeNaissance'])
    }
  end

  def build_person_base(person_data, additional_fields = {})
    description = safe_get(person_data, 'descriptionPersonne')
    base = build_person_identity_hash(description)
    base.merge(additional_fields)
  end

  def cac_actif_et_moral?(cac)
    cac['actif'] != false &&
      cac['typeDePersonne'] == TYPE_PERSONNE_MORALE &&
      cac['entreprise']
  end
end

class INSEE::AdresseEtablissement::BuildResource < INSEE::Etablissement::BuildResource
  def self.types_de_voie
    AppConfig.yaml_file(Rails.root.join('config/data/insee/types_de_voie.yml'))
  end

  def self.indices_repetition_de_voie
    AppConfig.yaml_file(Rails.root.join('config/data/insee/indices_repetition_de_voie.yml'))
  end

  protected

  def resource_attributes
    {
      siret: etablissement['siret'],
      siren: etablissement['siren'],
      diffusable_commercialement: diffusable_commercialement(etablissement['statutDiffusionEtablissement']),
      status_diffusion: STATUT_DIFFUSION[etablissement['statutDiffusionEtablissement']],
      complement_adresse: etablissement_address['complementAdresseEtablissement'],
      numero_voie: etablissement_address['numeroVoieEtablissement'],
      indice_repetition_voie: indices_repetition_de_voie[etablissement_address['indiceRepetitionEtablissement']] || etablissement_address['indiceRepetitionEtablissement'],
      type_voie: etablissement_address_type_de_voie.try(:upcase),
      libelle_voie: etablissement_address['libelleVoieEtablissement'],
      code_postal: etablissement_address['codePostalEtablissement'],
      libelle_commune: etablissement_address['libelleCommuneEtablissement'],
      libelle_commune_etranger: etablissement_address['libelleCommuneEtrangerEtablissement'],
      distribution_speciale: etablissement_address['distributionSpecialeEtablissement'],
      code_commune: etablissement_address['codeCommuneEtablissement'],
      code_cedex: etablissement_address['codeCedexEtablissement'],
      libelle_cedex: etablissement_address['libelleCedexEtablissement'],
      code_pays_etranger: etablissement_address['codePaysEtrangerEtablissement'],
      libelle_pays_etranger: etablissement_address['libellePaysEtrangerEtablissement'],
      type: type_of_person,

      acheminement_postal:,

      date_derniere_mise_a_jour: date_to_timestamp(etablissement['dateDernierTraitementEtablissement'])
    }
  end

  private

  def acheminement_postal
    {
      l1: acheminement_postal_denomination_personne_morale,
      l2: acheminement_postal_denomination_personne_physique,
      l3: etablissement_address['complementAdresseEtablissement'] || '',
      l4: acheminement_postal_voie,
      l5: etablissement_address['distributionSpecialeEtablissement'] || '',
      l6: acheminement_postal_cedex_or_postale,
      l7: etablissement_address['libellePaysEtrangerEtablissement'] || 'FRANCE'
    }
  end

  def acheminement_postal_denomination_personne_morale
    return '' unless type_of_person == :personne_morale

    [unite_legale['denominationUniteLegale'], unite_legale['denominationUsuelle1UniteLegale']].uniq.join(' ').squish
  end

  def acheminement_postal_denomination_personne_physique
    return '' unless type_of_person == :personne_physique

    [unite_legale['nomUniteLegale'], unite_legale['prenom1UniteLegale']].join(' ').squish
  end

  def acheminement_postal_voie
    [
      etablissement_address['numeroVoieEtablissement'],
      indices_repetition_de_voie[etablissement_address['indiceRepetitionEtablissement']],
      etablissement_address_type_de_voie,
      etablissement_address['libelleVoieEtablissement']
    ].compact.join(' ').upcase
  end

  def acheminement_postal_cedex_or_postale
    if etablissement_address['codeCedexEtablissement']
      [etablissement_address['codeCedexEtablissement'], etablissement_address['libelleCedexEtablissement']].join(' ')
    elsif etablissement_address['codePaysEtrangerEtablissement']
      etablissement_address['libelleCommuneEtrangerEtablissement']
    else
      [etablissement_address['codePostalEtablissement'], etablissement_address['libelleCommuneEtablissement']].join(' ')
    end
  end

  def etablissement_address
    @etablissement_address ||= etablissement['adresseEtablissement']
  end

  def etablissement
    context.etablissement || super
  end

  def unite_legale
    @unite_legale ||= etablissement['uniteLegale']
  end

  def etablissement_address_type_de_voie
    types_de_voie[etablissement_address['typeVoieEtablissement']] || etablissement_address['typeVoieEtablissement']
  end

  def types_de_voie
    self.class.types_de_voie
  end

  def indices_repetition_de_voie
    self.class.indices_repetition_de_voie
  end

  def type_of_person
    if categorie_juridique == '1000'
      :personne_physique
    else
      :personne_morale
    end
  end

  def categorie_juridique
    unite_legale['categorieJuridiqueUniteLegale']
  end
end

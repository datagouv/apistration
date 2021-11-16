class INSEE::AdresseEtablissement::BuildResource < INSEE::Etablissement::BuildResource
  protected

  def resource_attributes
    {
      id: etablissement['siret'],
      siren: etablissement['siren'],
      complement_adresse: etablissement_address['complementAdresseEtablissement'],
      numero_voie: etablissement_address['numeroVoieEtablissement'],
      indice_repetition_voie: indices_repetition_de_voie[etablissement_address['indiceRepetitionEtablissement']],
      type_voie: types_de_voie[etablissement_address['typeVoieEtablissement']].try(:upcase),
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
      date_derniere_mise_a_jour: date_to_timestamp(etablissement['dateDernierTraitementEtablissement'])
    }
  end

  private

  def etablissement_address
    @etablissement_address ||= etablissement['adresseEtablissement']
  end

  def types_de_voie
    @types_de_voie ||= YAML.load_file(Rails.root.join('config/data/insee/types_de_voie.yml'))
  end

  def indices_repetition_de_voie
    @indices_repetition_de_voie ||= YAML.load_file(Rails.root.join('config/data/insee/indices_repetition_de_voie.yml'))
  end
end

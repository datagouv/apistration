class ANTS::ExtraitImmatriculationVehicule::BuildResource < BuildResource
  ADRESSE_FIELD_MAPPING = {
    complement_information: 'cmplt',
    num_voie: 'numeroVoie',
    type_voie: 'typeVoie',
    libelle_voie: 'nomVoie',
    libelle_commune: 'commune',
    lieu_dit: 'lieuDit',
    etage_escalier_appartement: 'etgEscApt',
    extension: 'extIndRep'
  }.freeze

  def self.categorie_vehicule_labels
    load_yaml_data('ants/categorie_vehicule_labels.yml')
  end

  def self.genre_national_labels
    load_yaml_data('ants/genre_national_labels.yml')
  end

  def self.type_carburant_labels
    load_yaml_data('ants/type_carburant_labels.yml')
  end

  def self.classe_environnementale_labels
    load_yaml_data('ants/classe_environnementale_labels.yml')
  end

  def self.classe_environnementale_code_mappings
    load_yaml_data('ants/classe_environnementale_code_mappings.yml')
  end

  def self.load_yaml_data(file_path)
    AppConfig.yaml_file(Rails.root.join('config', 'data', file_path))
  end

  protected

  def resource_attributes
    {
      identite_particulier:,
      adresse_particulier:,
      statut_rattachement:,
      donnees_immatriculation_vehicule:,
      caracteristiques_techniques_vehicule:,
      matchings: { 'familyname' => true, 'givenname' => true },
      matches: true
    }
  end

  private

  def dossier
    @dossier ||= json_body['listeDossiers'].first
  end

  def identite
    dossier['personne']['identite']
  end

  def adresse
    dossier['personne']['adresse'] || {}
  end

  def caracteristiques_techniques
    dossier['vehicule']['caracteristiquesTechniques']
  end

  def identite_particulier
    {
      nom: identite['nomNaiss'],
      prenom: identite['prenom'],
      sexe_etat_civil: nil,
      annee_date_naissance: nil,
      mois_date_naissance: nil,
      jour_date_naissance: nil,
      code_departement_naissance: nil
    }
  end

  def adresse_particulier
    ADRESSE_FIELD_MAPPING.transform_values { |json_key| adresse[json_key] }.merge(
      code_postal_ville: adresse['codePostal']&.to_s,
      pays: nil
    )
  end

  def statut_rattachement
    identite['libelleQualite']&.downcase
  end

  def donnees_immatriculation_vehicule
    {
      numero_immatriculation: dossier['immatriculation']['numImmat'],
      date_premiere_immatriculation: dossier['immatriculation']['datePremImmat'],
      statut_location: {
        code: nil,
        label: nil
      }
    }
  end

  def caracteristiques_techniques_vehicule # rubocop:disable Metrics/AbcSize
    {
      marque: caracteristiques_techniques['marque'],
      type_variante_version: caracteristiques_techniques['tvv'],
      denomination_commerciale: caracteristiques_techniques['denominationCommerciale'],
      masse_charge_maximale: caracteristiques_techniques['ptac']&.to_i,
      categorie_vehicule: {
        code: categorie_vehicule_code,
        label: categorie_vehicule_labels[categorie_vehicule_code]
      },
      genre_national: {
        code: genre_national_code,
        label: genre_national_labels[genre_national_code]
      },
      cylindree: caracteristiques_techniques['cylindree']&.to_i,
      type_carburant: {
        code: type_carburant_code,
        label: type_carburant_labels[type_carburant_code]
      },
      taux_co2: caracteristiques_techniques['co2']&.to_i,
      classe_environnementale: {
        code: classe_environnementale_code,
        label: classe_environnementale_labels[classe_environnementale_code]
      }
    }
  end

  def categorie_vehicule_code
    caracteristiques_techniques['categorieCe']
  end

  def genre_national_code
    caracteristiques_techniques['genreNational']
  end

  def type_carburant_code
    caracteristiques_techniques['codeEnergie']
  end

  def classe_environnementale_code
    raw_code = caracteristiques_techniques['classeEnvironnementCe']

    classe_environnementale_code_mappings.each do |pattern, mapped_code|
      return mapped_code if raw_code&.match?(pattern)
    end

    raw_code
  end

  def categorie_vehicule_labels
    self.class.categorie_vehicule_labels
  end

  def genre_national_labels
    self.class.genre_national_labels
  end

  def type_carburant_labels
    self.class.type_carburant_labels
  end

  def classe_environnementale_labels
    self.class.classe_environnementale_labels
  end

  def classe_environnementale_code_mappings
    self.class.classe_environnementale_code_mappings
  end
end

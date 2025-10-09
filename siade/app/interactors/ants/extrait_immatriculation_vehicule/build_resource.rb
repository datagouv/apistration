class ANTS::ExtraitImmatriculationVehicule::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      identite_particulier:,
      adresse_particulier:,
      statut_rattachement:,
      donnees_immatriculation_vehicule:,
      caracteristiques_techniques_vehicule:
    }
  end

  private

  def identite_particulier
    {
      nom: identite_data[:nom_naissance],
      prenom: identite_data[:prenoms]&.first,
      sexe_etat_civil: identite_data[:sexe_etat_civil],
      annee_date_naissance: identite_data[:annee_date_naissance],
      mois_date_naissance: identite_data[:mois_date_naissance],
      jour_date_naissance: identite_data[:jour_date_naissance],
      code_departement_naissance: identite_data[:code_departement_naissance]
    }
  end

  def adresse_particulier
    address = matching_identity[:address_from_ants] || {}

    {
      complement_information: address[:complement_information],
      num_voie: address[:num_voie],
      type_voie: address[:type_voie],
      libelle_voie: address[:libelle_voie],
      code_postal_ville: address[:code_postal_ville],
      libelle_commune: address[:libelle_commune],
      lieu_dit: address[:lieu_dit],
      etage_escalier_appartement: address[:etage_escalier_appartement],
      extension: address[:extension],
      pays: address[:pays]
    }
  end

  def statut_rattachement
    matching_identity[:libelle_type_personne]
  end

  def identite_data
    matching_identity[:identite_from_ants]
  end

  def matching_identity
    @matching_identity ||= context.matched_identity
  end

  def xml_doc
    @xml_doc ||= Nokogiri::XML(context.response.body).remove_namespaces!
  end

  def donnees_immatriculation_vehicule
    {
      numero_immatriculation: xml_doc.at_xpath('//num_immat')&.text,
      date_premiere_immatriculation: xml_doc.at_xpath('//date_prem_immat')&.text,
      statut_location: {
        code: xml_doc.at_xpath('//code_type_immat')&.text,
        label: xml_doc.at_xpath('//libelle_type_immat')&.text
      }
    }
  end

  def caracteristiques_techniques_vehicule # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    {
      marque: xml_doc.at_xpath('//marque_vehicule')&.text,
      type_variante_version: xml_doc.at_xpath('//tvv')&.text,
      denomination_commerciale: xml_doc.at_xpath('//denomination_com')&.text,
      masse_charge_maximale: xml_doc.at_xpath('//ptac')&.text&.to_i,
      categorie_vehicule: {
        code: categorie_vehicule_code,
        label: categorie_vehicule_labels[categorie_vehicule_code]
      },
      genre_national: {
        code: genre_national_code,
        label: genre_national_labels[genre_national_code]
      },
      cylindree: xml_doc.at_xpath('//cylindree')&.text&.to_i,
      type_carburant: {
        code: type_carburant_code,
        label: type_carburant_labels[type_carburant_code]
      },
      taux_co2: xml_doc.at_xpath('//co2')&.text&.to_i,
      classe_environnementale: {
        code: classe_environnementale_code,
        label: classe_environnementale_labels[classe_environnementale_code]
      }
    }
  end

  def categorie_vehicule_code
    xml_doc.at_xpath('//categorie_ce')&.text
  end

  def genre_national_code
    xml_doc.at_xpath('//genre_national')&.text
  end

  def type_carburant_code
    xml_doc.at_xpath('//energie')&.text
  end

  def classe_environnementale_code
    raw_code = xml_doc.at_xpath('//classe_environnement_ce')&.text

    classe_environnementale_code_mappings.each do |pattern, mapped_code|
      return mapped_code if raw_code&.match?(pattern)
    end

    raw_code
  end

  def categorie_vehicule_labels
    @categorie_vehicule_labels ||= load_yaml_data('ants/categorie_vehicule_labels.yml')
  end

  def genre_national_labels
    @genre_national_labels ||= load_yaml_data('ants/genre_national_labels.yml')
  end

  def type_carburant_labels
    @type_carburant_labels ||= load_yaml_data('ants/type_carburant_labels.yml')
  end

  def classe_environnementale_labels
    @classe_environnementale_labels ||= load_yaml_data('ants/classe_environnementale_labels.yml')
  end

  def classe_environnementale_code_mappings
    @classe_environnementale_code_mappings ||= load_yaml_data('ants/classe_environnementale_code_mappings.yml')
  end

  def load_yaml_data(file_path)
    YAML.load_file(Rails.root.join('config', 'data', file_path))
  end
end

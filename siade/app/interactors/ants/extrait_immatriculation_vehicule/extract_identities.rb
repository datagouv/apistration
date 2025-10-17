class ANTS::ExtraitImmatriculationVehicule::ExtractIdentities < ApplicationInteractor
  def call
    context.extracted_identities = extract_identities_from_response
  end

  private

  def extract_identities_from_response
    personnes.map { |personne|
      next unless personne[:flag_pers_physique] == 'oui'

      {
        libelle_type_personne: personne[:libelle_type_personne],
        identite_from_ants: build_identite_from_ants(personne),
        address_from_ants: extract_address_fields(personne[:adresse_node])
      }
    }.compact
  end

  def xml_doc
    @xml_doc ||= Nokogiri::XML(context.response.body).remove_namespaces!
  end

  def personnes_nodes
    xml_doc.xpath('//liste_personnes/personne')
  end

  def personnes
    personnes_nodes.map { |personne| build_personne_data(personne) }.compact
  end

  def build_personne_data(personne)
    identite_personne = personne.at_xpath('identite_personne')
    {
      libelle_type_personne: libelle_type_personne(personne),
      flag_pers_physique: flag_pers_physique(identite_personne),
      nom_naissance: nom_naissance(identite_personne),
      nom_usage: nom_usage(identite_personne),
      prenom: prenom(identite_personne),
      sexe: sexe(identite_personne),
      date_naissance: date_naissance(identite_personne),
      code_dep_naissance: code_dep_naissance(identite_personne),
      adresse_node: personne.at_xpath('adresse_personne')
    }
  end

  def libelle_type_personne(personne)
    personne.at_xpath('libelle_type_personne')&.text
  end

  def flag_pers_physique(identite_personne)
    identite_personne.at_xpath('flag_pers_physique')&.text
  end

  def nom_naissance(identite_personne)
    identite_personne.at_xpath('nom_naiss')&.text
  end

  def nom_usage(identite_personne)
    identite_personne.at_xpath('nom_usage')&.text
  end

  def prenom(identite_personne)
    identite_personne.at_xpath('prenom')&.text
  end

  def sexe(identite_personne)
    identite_personne.at_xpath('sexe')&.text
  end

  def date_naissance(identite_personne)
    identite_personne.at_xpath('date_naissance')&.text
  end

  def code_dep_naissance(identite_personne)
    identite_personne.at_xpath('code_dep_naissance')&.text
  end

  def build_identite_from_ants(personne)
    date_parts = personne[:date_naissance]&.split('-')

    {
      nom_naissance: nom_from_ants(personne),
      prenoms: prenoms_from_ants(personne),
      sexe_etat_civil: personne[:sexe],
      annee_date_naissance: date_parts&.[](0)&.to_i,
      mois_date_naissance: date_parts&.[](1)&.to_i,
      jour_date_naissance: date_parts&.[](2)&.to_i,
      code_departement_naissance: personne[:code_dep_naissance]
    }.compact
  end

  def nom_from_ants(personne)
    payload_from_fni? ? personne[:nom_naissance].split.first : personne[:nom_naissance]
  end

  def prenoms_from_ants(personne)
    payload_from_fni? ? personne[:nom_naissance].split[1..] : personne[:prenom]&.split
  end

  def payload_from_fni?
    num_immat = xml_doc.at_xpath('//num_immat')&.text

    !num_immat.match?(siv_immatriculation_format)
  end

  def siv_immatriculation_format
    /\A[A-Z]{2}-\d{3}-[A-Z]{2}\z/
  end

  def extract_address_fields(adresse_node)
    return {} unless adresse_node

    address_mapping.transform_values { |xml_field| adresse_node.at_xpath(xml_field)&.text }.compact
  end

  def address_mapping
    {
      complement_information: 'compl_adresse',
      num_voie: 'num_voie',
      type_voie: 'type_voie',
      libelle_voie: 'libelle_voie',
      code_postal_ville: 'code_postal',
      libelle_commune: 'libelle_commune',
      lieu_dit: 'lieudit_ou_bp',
      etage_escalier_appartement: 'point_remise',
      extension: 'extension',
      pays: 'pays'
    }
  end
end

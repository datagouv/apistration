# frozen_string_literal: true

class ANTSRegistrationMatcherService
  attr_reader :ants_payload, :identite_france_connect

  def initialize(context:)
    @ants_payload = context.response.body
    @identite_france_connect = context[:params].slice(*matching_params)
  end

  def match?
    matching_personne.present?
  end

  def match_data
    if matching_personne
      {
        success: true,
        type_match: matching_personne[:libelle_type_personne],
        identite_from_ants: identite_from_ants(matching_personne),
        address_from_ants: address_from_ants(matching_personne)
      }
    else
      {
        success: false,
        type_match: nil,
        identite_from_ants: nil,
        address_from_ants: nil
      }
    end
  end

  private

  def matching_params
    %i[
      nom_naissance
      prenoms
      sexe_etat_civil
      annee_date_naissance
      mois_date_naissance
      jour_date_naissance
      code_cog_insee_commune_naissance
    ]
  end

  def matching_personne
    personnes_physiques.find { |personne| identites_and_commune_match?(personne, identite_france_connect) }
  end

  def identites_and_commune_match?(personne, identite_france_connect)
    return false unless identite_france_connect.except(:code_cog_insee_commune_naissance) == identite_from_ants(personne).except(:code_departement_naissance)

    return false unless identite_france_connect[:code_cog_insee_commune_naissance].start_with?(personne[:code_dep_naissance])

    true
  end

  def personnes_physiques
    personnes.select { |personne| personne[:flag_pers_physique] == 'oui' }
  end

  def personnes_physiques_identites
    personnes_physiques.map { |personne| identite_from_ants(personne) }&.compact
  end

  def payload_from_fni?
    num_immat = xml_doc.at_xpath('//num_immat')&.text

    !num_immat.match?(siv_immatriculation_format)
  end

  def siv_immatriculation_format
    /\A[A-Z]{2}-\d{3}-[A-Z]{2}\z/
  end

  def personnes
    personnes_nodes.map do |personne|
      identite_personne = personne.at_xpath('identite_personne')
      next unless identite_personne

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
  end

  def xml_doc
    @xml_doc ||= Nokogiri::XML(ants_payload).remove_namespaces!
  end

  def personnes_nodes
    xml_doc.xpath('//liste_personnes/personne')
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

  def identite_from_ants(personne)
    date_parts = personne[:date_naissance]&.split('-')

    {
      nom_naissance: nom_from_ants(personne),
      prenoms: prenoms_from_ants(personne),
      sexe_etat_civil: personne[:sexe],
      annee_date_naissance: date_parts[0]&.to_i,
      mois_date_naissance: date_parts[1]&.to_i,
      jour_date_naissance: date_parts[2]&.to_i,
      code_departement_naissance: personne[:code_dep_naissance]
    }.compact
  end

  def nom_from_ants(personne)
    payload_from_fni? ? personne[:nom_naissance].split.first : personne[:nom_naissance]
  end

  def prenoms_from_ants(personne)
    payload_from_fni? ? personne[:nom_naissance].split[1..] : personne[:prenom]&.split
  end

  def address_from_ants(personne)
    extract_address_fields(personne[:adresse_node])
  end

  def extract_address_fields(adresse_node)
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

class SIADE::V2::Drivers::Associations < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret

  default_to_nil_raw_fetching_methods :id, :titre, :objet, :siren, :siret_siege_social,
    :date_creation, :date_declaration, :date_publication, :date_dissolution,
    :adresse_siege_complement_1, :adresse_siege_complement_2, :adresse_siege_complement_3,
    :adresse_siege_numero_voie, :adresse_siege_type_voie,
    :adresse_siege_libelle_voie, :adresse_siege_distribution, :adresse_siege_code_insee,
    :adresse_siege_code_postal, :adresse_siege_commune,
    :code_civilite_dirigeant, :civilite_dirigeant,
    :code_etat, :etat,
    :code_groupement, :groupement,
    :mise_a_jour,
    :nombre_documents, :documents,
    :error

  def initialize(hash)
    association_id = hash[:association_id]
    @siret = association_id if Siret.new(association_id).valid?
    @id = association_id if RNAId.new(association_id).valid?
  end

  def provider_name
    'RNA'
  end

  def request
    @request ||= SIADE::V2::Requests::Associations.new(@id || @siret)
  end

  def check_response; end

  protected

  def id_raw
    @id || association_information['asso']['identite']['id_rna']
  end

  def titre_raw
    association_information['asso']['identite']['nom']
  end

  def objet_raw
    association_information['asso']['activites']['objet']
  end

  def siren_raw
    association_information['asso']['identite']['id_siren']
  end

  def siret_siege_social_raw
    association_information['asso']['identite']['id_siret_siege']
  end

  def date_creation_raw
    association_information['asso']['identite']['date_creat']
  end

  def date_declaration_raw
    association_information['asso']['identite']['date_modif_rna']
  end

  def date_publication_raw
    association_information['asso']['identite']['date_pub_jo']
  end

  def date_dissolution_raw
    association_information['asso']['identite']['date_dissolution']
  end

  def adresse_siege_complement_1_raw
    association_information['asso']['coordonnees']['adresse_siege']['cplt_1']
  end

  def adresse_siege_complement_2_raw
    association_information['asso']['coordonnees']['adresse_siege']['cplt_2']
  end

  def adresse_siege_complement_3_raw
    association_information['asso']['coordonnees']['adresse_siege']['cplt_3']
  end

  def adresse_siege_numero_voie_raw
    association_information['asso']['coordonnees']['adresse_siege']['num_voie']
  end

  def adresse_siege_type_voie_raw
    association_information['asso']['coordonnees']['adresse_siege']['type_voie']
  end

  def adresse_siege_libelle_voie_raw
    association_information['asso']['coordonnees']['adresse_siege']['voie']
  end

  def adresse_siege_distribution_raw
    association_information['asso']['coordonnees']['adresse_siege']['bp']
  end

  def adresse_siege_code_insee_raw
    association_information['asso']['coordonnees']['adresse_siege']['code_insee']
  end

  def adresse_siege_code_postal_raw
    association_information['asso']['coordonnees']['adresse_siege']['cp']
  end

  def adresse_siege_commune_raw
    association_information['asso']['coordonnees']['adresse_siege']['commune']
  end

  def code_civilite_dirigeant_raw; end

  def civilite_dirigeant_raw; end

  def code_etat_raw; end

  def etat_raw
    association_information['asso']['identite']['active']
  end

  def code_groupement_raw; end

  def groupement_raw
    association_information['asso']['identite']['groupement']
  end

  def mise_a_jour_raw
    association_information['asso']['identite']['date_modif_rna']
  end

  def nombre_documents_raw
    association_information['asso']['documents']['nbDocRna'].to_i
  end

  def documents_raw
    documents = nombre_documents_raw.zero? ? [] : Array[association_information['asso']['documents']['document_rna']].flatten
    documents.map { |doc| rework_document_structure(doc) }
  end

  def error_raw
    association_information['asso']['erreur']
  end

  private

  def association_information
    @association_information ||=
      begin
        Hash.from_xml(response.body)
      rescue StandardError
        Rails.logger.error
        set_error_message_for(502)
      end
  end

  def set_error_message_502
    errors << RNAError.new(:incorrect_xml)
  end

  def rework_document_structure(doc)
    delete_hash_fields(doc, %w[sous_type annee even id])
    doc['type'] = doc.delete('lib_sous_type')
    doc['timestamp'] = doc.delete('time')
    doc
  end

  def delete_hash_fields(hash, fields)
    fields.each { |field| hash.delete(field) }
    hash
  end
end

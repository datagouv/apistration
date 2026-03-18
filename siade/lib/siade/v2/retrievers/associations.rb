class SIADE::V2::Retrievers::Associations < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :association_id
  register_driver :association, class_name: SIADE::V2::Drivers::Associations, init_with: :association_id

  fetch_attributes_through_driver :association,
                                  :http_code,
                                  :id, :titre, :objet, :siren, :siret, :siret_siege_social,
                                  :date_creation, :date_declaration, :date_publication, :date_dissolution,
                                  :adresse_siege_complement_1, :adresse_siege_complement_2, :adresse_siege_complement_3,
                                  :adresse_siege_numero_voie, :adresse_siege_type_voie,
                                  :adresse_siege_libelle_voie, :adresse_siege_distribution, :adresse_siege_code_insee,
                                  :adresse_siege_code_postal, :adresse_siege_commune,
                                  :code_civilite_dirigeant, :civilite_dirigeant,
                                  :code_etat, :etat,
                                  :code_groupement, :groupement,
                                  :mise_a_jour

  def initialize(association_id)
    @association_id = association_id
  end

  def retrieve
    driver_association.perform_request
  end

  def adresse_siege
    {
      complement:   [adresse_siege_complement_1, adresse_siege_complement_2, adresse_siege_complement_3].join(' '),
      numero_voie:  adresse_siege_numero_voie,
      type_voie:    adresse_siege_type_voie,
      libelle_voie: adresse_siege_libelle_voie,
      distribution: adresse_siege_distribution,
      code_insee:   adresse_siege_code_insee,
      code_postal:  adresse_siege_code_postal,
      commune:      adresse_siege_commune
    }
  end
end

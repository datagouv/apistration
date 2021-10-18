class SIADE::V2::Retrievers::EntreprisesRestored < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren
  attr_accessor :numero_tva_intracommunautaire

  register_driver :v3_entreprise, class_name: SIADE::V2::Drivers::INSEE::Entreprise, init_with: :siren
  register_driver :infogreffe, class_name: SIADE::V2::Drivers::Infogreffe, init_with: :siren, init_options: :driver_infogreffe_options

  fetch_attributes_through_driver :infogreffe,
    :nom_commercial,
    :date_radiation,
    :capital_social,
    :mandataires_sociaux

  fetch_attributes_through_driver :v3_entreprise,
    :categorie_juridique,
    :sigle,
    :activite_principale,
    :siret_siege_social,
    :tranche_effectif_salarie,
    :date_creation,
    :nom,
    :nom_usage,
    :prenom_1,
    :prenom_2,
    :prenom_3,
    :etat_administratif,
    :date_cessation,
    :diffusable_commercialement,
    :categorie_entreprise,
    :http_code

  def initialize(siren)
    @siren = siren
  end

  def retrieve
    driver_v3_entreprise.perform_request
    driver_infogreffe.perform_request
    @numero_tva_intracommunautaire = compute_numero_tva_intracommunautaire
  end

  def siren_redirected_to_another_siren?
    siren != driver_v3_entreprise.siren
  end

  def redirected_siren
    driver_v3_entreprise.siren
  end

  def raison_sociale
    if entrepreneur_individuel?
      driver_v3_entreprise.raison_sociale || noms_prenoms
    else
      driver_v3_entreprise.raison_sociale
    end
  end

  def tranche_effectif_salarie_entreprise
    tranche_effectif_salarie.as_json
  end

  def procedure_collective
    false
  end

  def etat_administratif
    {
      value: driver_v3_entreprise.etat_administratif,
      date_cessation: date_cessation
    }
  end

  def diffusable_commercialement?
    diffusable_commercialement
  end

  def entrepreneur_individuel?
    categorie_juridique.code == '1000'
  end

  def noms_prenoms
    "#{noms}/#{prenoms}/"
  end

  def noms
    [nom, nom_usage].join('*')
  end

  def prenoms
    [prenom_1, prenom_2, prenom_3].join(' ')
  end

  def forme_juridique
    categorie_juridique.libelle
  end

  def forme_juridique_code
    categorie_juridique.code
  end

  def enseigne
    sigle
  end

  def libelle_naf
    activite_principale.libelle
  end

  def naf
    activite_principale.code_dotless
  end

  def code_effectif_entreprise
    tranche_effectif_salarie.code
  end

  def prenom
    prenom_1
  end

  def compute_numero_tva_intracommunautaire
    TVAIntracommunautaire.new(siren).perform
  end

  def driver_infogreffe_options
    { placeholder_to_nil: true }
  end
end

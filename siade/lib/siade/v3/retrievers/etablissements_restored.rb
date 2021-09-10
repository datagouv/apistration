class SIADE::V3::Retrievers::EtablissementsRestored < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siret

  register_driver :v3_etab, class_name: SIADE::V3::Drivers::INSEE::Etablissement, init_with: :siret
  register_driver :geo_localite, class_name: SIADE::V3::Drivers::Geo::Localite, init_with: :code_commune

  fetch_attributes_through_driver :v3_etab,
    :date_creation,
    :siege_social,
    :date_dernier_traitement,
    :adresse,
    :adresse_francaise?,
    :activite_principale,
    :diffusable_commercialement,
    :tranche_effectif_salarie,
    :enseignes,
    :etat_administratif,
    :date_fermeture,
    :entreprise,
    :http_code

  fetch_attributes_through_driver :geo_localite, :region, :commune

  def initialize(siret)
    @siret = siret
  end

  def retrieve
    driver_v3_etab.perform_request
    return unless driver_v3_etab.success?
    return if siret_redirected_to_another_siret?

    driver_geo_localite.perform_request
  end

  def siret_redirected_to_another_siret?
    siret != driver_v3_etab.siret
  end

  def redirected_siret
    driver_v3_etab.siret
  end

  def siege_social?
    siege_social
  end

  def date_creation_etablissement
    date_creation
  end

  def naf
    activite_principale.code_dotless
  end

  def libelle_naf
    activite_principale.libelle
  end

  def date_mise_a_jour
    date_dernier_traitement
  end

  def region_implantation
    {
      code: region[:code],
      value: region[:value]
    }
  end

  def commune_implantation
    {
      code: commune[:code],
      value: commune[:value] || adresse[:libelle_commune_etranger]
    }
  end

  def pays_implantation
    if adresse_francaise?
      {
        code: 'FR',
        value: 'FRANCE'
      }
    else
      {
        code: adresse[:code_pays_etranger],
        value: adresse[:libelle_pays_etranger]
      }
    end
  end

  def diffusable_commercialement?
    diffusable_commercialement
  end

  def enseigne
    enseignes
  end

  def tranche_effectif_salarie_etablissement
    tranche_effectif_salarie.as_json
  end

  def l1
    l1_pm || l1_pp
  end

  def l1_pm
    entreprise[:raison_sociale]&.squish
  end

  def l1_pp
    [
      civilite_pp,
      entreprise[:prenom_1],
      entreprise[:nom_usage] || entreprise[:nom]
    ]
      .compact
      .join(' ')
      .squish
  end

  def civilite_pp
    case entreprise[:sexe]
    when 'M'
      'MONSIEUR'
    when 'F'
      'MADAME'
    end
  end

  def l2
    concat_raison_sociale || enseignes
  end

  def l3
    adresse[:complement_adresse]
  end

  def l4
    join_or_nil_if_empty [
      adresse[:numero_voie],
      adresse[:indice_repetition],
      adresse[:type_voie],
      adresse[:libelle_voie]
    ]
  end

  def l5
    adresse[:distribution_speciale]
  end

  def l6
    join_or_nil_if_empty [
      adresse[:code_cedex] || adresse[:code_postal],
      adresse[:libelle_cedex] || adresse[:libelle_commune] || adresse[:libelle_commune_etranger]
    ]
  end

  def l7
    if adresse_francaise?
      'FRANCE'
    else
      adresse[:libelle_pays_etranger]
    end
  end

  def localite
    adresse[:libelle_commune] || adresse[:libelle_commune_etranger]
  end

  def numero_voie
    adresse[:numero_voie]
  end

  def type_voie
    adresse[:type_voie]
  end

  def nom_voie
    adresse[:libelle_voie]
  end

  def complement_adresse
    adresse[:complement_adresse]
  end

  def code_postal
    adresse[:code_postal]
  end

  def code_commune
    adresse[:code_commune]
  end

  def code_insee_localite
    code_commune
  end

  def cedex
    adresse[:code_cedex]
  end

  private

  def concat_raison_sociale
    join_or_nil_if_empty [
      entreprise[:raison_sociale_usuelle_1],
      entreprise[:raison_sociale_usuelle_2],
      entreprise[:raison_sociale_usuelle_3]
    ]
  end

  def join_or_nil_if_empty(elements)
    elements = elements.compact
      .delete_if(&:empty?)

    elements.empty? ? nil : elements.join(' ')
  end
end

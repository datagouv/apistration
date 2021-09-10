class SIADE::V2::Drivers::BilansEntreprisesBDF < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siren

  default_to_nil_raw_fetching_methods :monnaie, :bilans

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'Banque de France'
  end

  def request
    @request ||= SIADE::V2::Requests::BilansEntreprisesBDF.new(@siren)
  end

  def check_response; end

  def monnaie_raw
    bdf_information['monnaie']
  end

  def bilans_raw
    bdf_information['bilans']
  end

  protected

  def bdf_information
    @bdf_information ||= parsed_json_with_formatted_and_prettier_keys
  rescue JSON::ParserError => e
    Rails.logger.error e.message
    ''
  end

  def parsed_json_with_formatted_and_prettier_keys
    parsed_json = JSON.parse(response.body)

    parsed_json.deep_transform_keys!(&:underscore)
    rename_bilans_raws_keys!(parsed_json['bilans'])

    parsed_json
  end

  def rename_bilans_raws_keys!(bilans_raws)
    bilans_raws.each do |bilan_raw|
      rename_bilan_raw_keys!(bilan_raw)
    end
  end

  def rename_bilan_raw_keys!(bilan_raw)
    BILAN_RAW_KEYS_REMAPPING.each do |original, new|
      rename_hash_key(bilan_raw, original, new)
    end
  end

  def rename_hash_key(hash, original, new)
    hash[new] = hash.delete(original)
  end

  BILAN_RAW_KEYS_REMAPPING =
    {
      'ca_ht' => 'chiffre_affaires_ht',
      'caf' => 'capacite_autofinancement',
      'date_arrete' => 'date_arret_exercice',
      'dettes3_emrunts_et_dettes_aupres_des_etablissementsde_credit' => 'dettes3_emprunts_et_dettes_aupres_des_etablissements_de_credit',
      'dettes4_dont_a_un_an_au_plus' => 'dettes4_maturite_a_un_an_au_plus',
      'dont_autres_fonds_propres' => 'autres_fonds_propres',
      'dont_capital_social' => 'capital_social_inclus_dans_capitaux_propres_et_assimiles',
      'ebe' => 'excedent_brut_exploitation',
      'evolution_ca_ht' => 'evolution_chiffre_affaires_ht',
      'evolution_caf' => 'evolution_capacite_autofinancement',
      'evolution_dettes3_emprunts_et_dettes_aupres_des_etablissementsde_credit' => 'evolution_dettes3_emprunts_et_dettes_aupres_des_etablissements_de_credit',
      'evolution_dettes4_dont_a_un_an_au_plus' => 'evolution_dettes4_maturite_a_un_an_au_plus',
      'evolution_dont_autres_fonds_propres' => 'evolution_autres_fonds_propres',
      'evolution_dont_capital_social' => 'evolution_capital_social_inclus_dans_capitaux_propres_et_assimiles',
      'evolution_ebe' => 'evolution_excedent_brut_exploitation',
      'evolution_frng' => 'evolution_fonds_roulement_net_global',
      'evolution_frng/bfr' => 'evolution_ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement',
      'evolution_totaltotal_dettes_stables' => 'evolution_total_dettes_stables',
      'frng' => 'fonds_roulement_net_global',
      'frng/bfr' => 'ratio_fonds_roulement_net_global_sur_besoin_en_fonds_de_roulement'
    }
end

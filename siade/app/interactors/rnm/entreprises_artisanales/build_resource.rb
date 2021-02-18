class RNM::EntreprisesArtisanales::BuildResource < BuildResource
  def call
    # Has to be an object which respond to method for JSON API
    context.resource = Hashie::Mash.new(build_resource)
  end

  def build_resource
    {
      # Jsonapi::MandatoryField: d is a mandatory field in the jsonapi spec
      id: value_or_placeholder('ent_id_siren'),
      siren: value_or_placeholder('ent_id_siren'),
      etablissement_origine_id: value_or_placeholder('ent_id_origine'),

      modalite_exercice: value_or_placeholder('ent_act_modalite_exercice'),
      non_sedentaire: value_or_placeholder('ent_act_non_sedentaire'),
      activite_artisanales_declarees: value_or_placeholder('ent_act_activite_artisanales_declarees'),
      denomination_sociale: value_or_placeholder('ent_act_denomination_sociale'),
      sigle: value_or_placeholder('ent_act_sigle'),

      declaration_procedures: value_or_placeholder('ent_jug_procedures'),

      code_cfe: value_or_placeholder('gest_emetteur'),
      categorie_personne: value_or_placeholder('gest_categorie'),
      libelle_epci: value_or_placeholder('epci'),
      code_norme_activite_entreprises: value_or_placeholder('ent_act_code_apen'),
    }.merge(
      rnm_payload,
    ).merge(
      adresse_payload,
    ).merge(
      dirigeant_payload,
    ).merge(
      effectif_payload,
    ).merge(
      dates_payload,
    ).merge(
      code_nafa_payload,
    ).merge(
      forme_juridique_payload,
    ).merge(
      secteur_activite_nar_payload,
    ).merge(
      eirl_payload,
    )
  end

  private

  def rnm_payload
    {
      rnm_id:               value_or_placeholder('id'),
      rnm_numero_gestion:   value_or_placeholder('ent_id_num_gestion'),
      rnm_date_import:      value_or_placeholder('gest_date_maj'),
      rnm_date_mise_a_jour: value_or_placeholder('gest_maj_fichier'),
    }
  end

  def adresse_payload
    {
      adresse_numero_voie:            value_or_placeholder('ent_adr_numero_voie'),
      adresse_indice_repetition_voie: value_or_placeholder('ent_adr_indice_repetition'),
      adresse_type_voie:              value_or_placeholder('ent_adr_type_voie'),
      adresse_libelle_voie:           value_or_placeholder('ent_adr_adresse'),
      adresse_complement:             value_or_placeholder('ent_adr_adresse_complement'),
      adresse_code_postal:            value_or_placeholder('ent_adr_code_postal'),
      adresse_commune:                value_or_placeholder('ent_adr_commune'),
      adresse_commune_cog:            value_or_placeholder('ent_adr_commune_cog'),
      adresse_departement:            value_or_placeholder('gest_dept'),
      adresse_region:                 value_or_placeholder('gest_reg'),
    }
  end

  def dirigeant_payload
    {
      dirigeant_qualification:      value_or_placeholder('dir_qa_qualification'),
      dirigeant_nom_de_naissance:   value_or_placeholder('dir_id_nom_naissance'),
      dirigeant_nom_usage:          value_or_placeholder('dir_id_nom_usage'),
      dirigeant_prenom1:            value_or_placeholder('dir_id_prenom_1'),
      dirigeant_prenom2:            value_or_placeholder('dir_id_prenom_2'),
      dirigeant_prenom3:            value_or_placeholder('dir_id_prenom_3'),
      dirigeant_pseudonyme:         value_or_placeholder('dir_id_pseudonyme'),
      dirigeant_date_de_naissance:  value_or_placeholder('dir_id_date_naissance'),
      dirigeant_lieu_de_naissance:  value_or_placeholder('dir_id_lieu_naissance'),
    }
  end

  def effectif_payload
    {
      effectif_salarie:   value_or_placeholder('ent_eff_salarie'),
      effectif_apprenti:  value_or_placeholder('ent_eff_apprenti'),
    }
  end

  def dates_payload
    {
      date_immatriculation:       value_or_placeholder('ent_act_date_immat_rm'),
      date_radiation:             value_or_placeholder('ent_act_date_radiation'),
      date_debut_activite:        value_or_placeholder('ent_act_date_debut_activite'),
      date_cessation_activite:    value_or_placeholder('ent_act_date_cessation_activite'),
      date_cloture_liquidation:   value_or_placeholder('ent_act_date_cloture_liquidation'),
      date_transfert_patrimoine:  value_or_placeholder('ent_act_date_transfert_patrimoine'),
      date_dissolution:           value_or_placeholder('ent_act_date_dissolution'),
    }
  end

  def code_nafa_payload
    {
      code_nafa_principal:    value_or_placeholder('ent_act_code_nafa_principal'),
      code_nafa_secondaire1:  value_or_placeholder('ent_act_code_nafa_secondaire_1'),
      code_nafa_secondaire2:  value_or_placeholder('ent_act_code_nafa_secondaire_2'),
      code_nafa_secondaire3:  value_or_placeholder('ent_act_code_nafa_secondaire_3'),
      code_nafa_libelle:      value_or_placeholder('gest_libelle_code_nafa'),
    }
  end

  def secteur_activite_nar_payload
    {
      secteur_activite_intitule_nar_4:   value_or_placeholder('gest_nar_4'),
      secteur_activite_intitule_nar_20:  value_or_placeholder('gest_nar_20'),
    }
  end

  def forme_juridique_payload
    {
      forme_juridique_id:     value_or_placeholder('ent_act_forme_juridique'),
      forme_juridique_label:  value_or_placeholder('gest_label_forme_juridique'),
    }
  end

  def eirl_payload
    {
      eirl_id_registre:     value_or_placeholder('eirl_denomination'),
      eirl_denomination:    value_or_placeholder('eirl_init_nom_registre'),
      eirl_objet_activite: value_or_placeholder('eirl_objet_dap'),
      eirl_date_depot:      value_or_placeholder('eirl_date_depot'),
    }
  end

  def value_or_placeholder(key)
    if json_body.key?(key)
      json_body[key]
    else
      track_missing_data(key, build_exception_error(key, caller))
      set_error_message_for 206 if success?
      placeholder
    end
  end

  def build_exception_error(key, backtrace)
    exception = ArgumentError.new("#{key} should be present in response payload")
    exception.set_backtrace(backtrace)
    exception
  end
end

class RNM::EntreprisesArtisanales::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      etablissement_origine_id: json_body['ent_id_origine'],

      modalite_exercice: json_body['ent_act_modalite_exercice'],
      non_sedentaire: json_body['ent_act_non_sedentaire'],
      activite_artisanales_declarees: json_body['ent_act_activite_artisanales_declarees'],
      denomination_sociale: json_body['ent_act_denomination_sociale'],
      sigle: json_body['ent_act_sigle'],

      declaration_procedures: json_body['ent_jug_procedures'],

      code_cfe: json_body['gest_emetteur'],
      categorie_personne: json_body['gest_categorie'],
      libelle_epci: json_body['epci'],
      code_norme_activite_entreprises: json_body['ent_act_code_apen']
    }.merge(
      rnm_payload
    ).merge(
      adresse_payload
    ).merge(
      dirigeant_payload
    ).merge(
      effectif_payload
    ).merge(
      dates_payload
    ).merge(
      code_nafa_payload
    ).merge(
      forme_juridique_payload
    ).merge(
      secteur_activite_nar_payload
    ).merge(
      eirl_payload
    )
  end

  private

  def rnm_payload
    {
      rnm_id: json_body['id'],
      rnm_numero_gestion: json_body['ent_id_num_gestion'],
      rnm_date_import: json_body['gest_date_maj'],
      rnm_date_mise_a_jour: json_body['gest_maj_fichier']
    }
  end

  def adresse_payload # rubocop:disable Metrics/AbcSize
    {
      # FIXME: JSONAPI use this field to retrieve the relationship
      adresse_id: json_body['ent_id_siren'],
      # NOTE: this payload won't be send to end-user because relationship data includes only type and id
      adresse: Resource.new(
        # FIXME
        # Jsonapi::MandatoryField: id is a mandatory field in the jsonapi spec
        id: json_body['ent_id_siren'],
        numero_voie: json_body['ent_adr_numero_voie'],
        indice_repetition_voie: json_body['ent_adr_indice_repetition'],
        type_voie: json_body['ent_adr_type_voie'],
        libelle_voie: json_body['ent_adr_adresse'],
        complement: json_body['ent_adr_adresse_complement'],
        code_postal: json_body['ent_adr_code_postal'],
        commune: json_body['ent_adr_commune'],
        commune_cog: json_body['ent_adr_commune_cog'],
        departement: json_body['gest_dept'],
        region: json_body['gest_reg']
      )
    }
  end

  def dirigeant_payload # rubocop:disable Metrics/AbcSize
    {
      dirigeant_qualification: json_body['dir_qa_qualification'],
      dirigeant_nom_de_naissance: json_body['dir_id_nom_naissance'],
      dirigeant_nom_usage: json_body['dir_id_nom_usage'],
      dirigeant_prenom1: json_body['dir_id_prenom_1'],
      dirigeant_prenom2: json_body['dir_id_prenom_2'],
      dirigeant_prenom3: json_body['dir_id_prenom_3'],
      dirigeant_pseudonyme: json_body['dir_id_pseudonyme'],
      dirigeant_date_de_naissance: json_body['dir_id_date_naissance'],
      dirigeant_lieu_de_naissance: json_body['dir_id_lieu_naissance']
    }
  end

  def effectif_payload
    {
      effectif_salarie: json_body['ent_eff_salarie'],
      effectif_apprenti: json_body['ent_eff_apprenti']
    }
  end

  def dates_payload
    {
      date_immatriculation: json_body['ent_act_date_immat_rm'],
      date_radiation: json_body['ent_act_date_radiation'],
      date_debut_activite: json_body['ent_act_date_debut_activite'],
      date_cessation_activite: json_body['ent_act_date_cessation_activite'],
      date_cloture_liquidation: json_body['ent_act_date_cloture_liquidation'],
      date_transfert_patrimoine: json_body['ent_act_date_transfert_patrimoine'],
      date_dissolution: json_body['ent_act_date_dissolution']
    }
  end

  def code_nafa_payload
    {
      code_nafa_principal: json_body['ent_act_code_nafa_principal'],
      code_nafa_secondaire1: json_body['ent_act_code_nafa_secondaire_1'],
      code_nafa_secondaire2: json_body['ent_act_code_nafa_secondaire_2'],
      code_nafa_secondaire3: json_body['ent_act_code_nafa_secondaire_3'],
      code_nafa_libelle: json_body['gest_libelle_code_nafa']
    }
  end

  def secteur_activite_nar_payload
    {
      secteur_activite_intitule_nar_4: json_body['gest_nar_4'],
      secteur_activite_intitule_nar_20: json_body['gest_nar_20']
    }
  end

  def forme_juridique_payload
    {
      forme_juridique_id: json_body['ent_act_forme_juridique'],
      forme_juridique_label: json_body['gest_label_forme_juridique']
    }
  end

  def eirl_payload
    {
      eirl_id_registre: json_body['eirl_denomination'],
      eirl_denomination: json_body['eirl_init_nom_registre'],
      eirl_objet_activite: json_body['eirl_objet_dap'],
      eirl_date_depot: json_body['eirl_date_depot']
    }
  end
end

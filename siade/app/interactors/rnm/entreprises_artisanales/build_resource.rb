class RNM::EntreprisesArtisanales::BuildResource < BuildResource
  protected

  def resource_attributes
    {
<<<<<<< HEAD
      id:                              json_body['ent_id_siren'],
      siren:                           json_body['ent_id_siren'],
      etablissement_origine_id:        json_body['ent_id_origine'],

      modalite_exercice:               json_body['ent_act_modalite_exercice'],
      non_sedentaire:                  json_body['ent_act_non_sedentaire'],
      activite_artisanales_declarees:  json_body['ent_act_activite_artisanales_declarees'],
      denomination_sociale:            json_body['ent_act_denomination_sociale'],
      sigle:                           json_body['ent_act_sigle'],

      declaration_procedures:          json_body['ent_jug_procedures'],

      code_cfe:                        json_body['gest_emetteur'],
      categorie_personne:              json_body['gest_categorie'],
      libelle_epci:                    json_body['epci'],
      code_norme_activite_entreprises: json_body['ent_act_code_apen'],
=======
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
      code_norme_activite_entreprises: value_or_placeholder('ent_act_code_apen')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
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
<<<<<<< HEAD
      rnm_id:               json_body['id'],
      rnm_numero_gestion:   json_body['ent_id_num_gestion'],
      rnm_date_import:      json_body['gest_date_maj'],
      rnm_date_mise_a_jour: json_body['gest_maj_fichier'],
=======
      rnm_id: value_or_placeholder('id'),
      rnm_numero_gestion: value_or_placeholder('ent_id_num_gestion'),
      rnm_date_import: value_or_placeholder('gest_date_maj'),
      rnm_date_mise_a_jour: value_or_placeholder('gest_maj_fichier')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def adresse_payload
    {
      # FIXME: JSONAPI use this field to retrieve the relationship
      adresse_id: json_body['ent_id_siren'],
      # NOTE: this payload won't be send to end-user because relationship data includes only type and id
      adresse: Resource.new(
        # FIXME
        # Jsonapi::MandatoryField: id is a mandatory field in the jsonapi spec
<<<<<<< HEAD
        id:                     json_body['ent_id_siren'],
        numero_voie:            json_body['ent_adr_numero_voie'],
        indice_repetition_voie: json_body['ent_adr_indice_repetition'],
        type_voie:              json_body['ent_adr_type_voie'],
        libelle_voie:           json_body['ent_adr_adresse'],
        complement:             json_body['ent_adr_adresse_complement'],
        code_postal:            json_body['ent_adr_code_postal'],
        commune:                json_body['ent_adr_commune'],
        commune_cog:            json_body['ent_adr_commune_cog'],
        departement:            json_body['gest_dept'],
        region:                 json_body['gest_reg'],
=======
        id: value_or_placeholder('ent_id_siren'),
        numero_voie: value_or_placeholder('ent_adr_numero_voie'),
        indice_repetition_voie: value_or_placeholder('ent_adr_indice_repetition'),
        type_voie: value_or_placeholder('ent_adr_type_voie'),
        libelle_voie: value_or_placeholder('ent_adr_adresse'),
        complement: value_or_placeholder('ent_adr_adresse_complement'),
        code_postal: value_or_placeholder('ent_adr_code_postal'),
        commune: value_or_placeholder('ent_adr_commune'),
        commune_cog: value_or_placeholder('ent_adr_commune_cog'),
        departement: value_or_placeholder('gest_dept'),
        region: value_or_placeholder('gest_reg')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
      )
    }
  end

  def dirigeant_payload
    {
<<<<<<< HEAD
      dirigeant_qualification:     json_body['dir_qa_qualification'],
      dirigeant_nom_de_naissance:  json_body['dir_id_nom_naissance'],
      dirigeant_nom_usage:         json_body['dir_id_nom_usage'],
      dirigeant_prenom1:           json_body['dir_id_prenom_1'],
      dirigeant_prenom2:           json_body['dir_id_prenom_2'],
      dirigeant_prenom3:           json_body['dir_id_prenom_3'],
      dirigeant_pseudonyme:        json_body['dir_id_pseudonyme'],
      dirigeant_date_de_naissance: json_body['dir_id_date_naissance'],
      dirigeant_lieu_de_naissance: json_body['dir_id_lieu_naissance'],
=======
      dirigeant_qualification: value_or_placeholder('dir_qa_qualification'),
      dirigeant_nom_de_naissance: value_or_placeholder('dir_id_nom_naissance'),
      dirigeant_nom_usage: value_or_placeholder('dir_id_nom_usage'),
      dirigeant_prenom1: value_or_placeholder('dir_id_prenom_1'),
      dirigeant_prenom2: value_or_placeholder('dir_id_prenom_2'),
      dirigeant_prenom3: value_or_placeholder('dir_id_prenom_3'),
      dirigeant_pseudonyme: value_or_placeholder('dir_id_pseudonyme'),
      dirigeant_date_de_naissance: value_or_placeholder('dir_id_date_naissance'),
      dirigeant_lieu_de_naissance: value_or_placeholder('dir_id_lieu_naissance')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def effectif_payload
    {
<<<<<<< HEAD
      effectif_salarie:  json_body['ent_eff_salarie'],
      effectif_apprenti: json_body['ent_eff_apprenti'],
=======
      effectif_salarie: value_or_placeholder('ent_eff_salarie'),
      effectif_apprenti: value_or_placeholder('ent_eff_apprenti')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def dates_payload
    {
<<<<<<< HEAD
      date_immatriculation:      json_body['ent_act_date_immat_rm'],
      date_radiation:            json_body['ent_act_date_radiation'],
      date_debut_activite:       json_body['ent_act_date_debut_activite'],
      date_cessation_activite:   json_body['ent_act_date_cessation_activite'],
      date_cloture_liquidation:  json_body['ent_act_date_cloture_liquidation'],
      date_transfert_patrimoine: json_body['ent_act_date_transfert_patrimoine'],
      date_dissolution:          json_body['ent_act_date_dissolution'],
=======
      date_immatriculation: value_or_placeholder('ent_act_date_immat_rm'),
      date_radiation: value_or_placeholder('ent_act_date_radiation'),
      date_debut_activite: value_or_placeholder('ent_act_date_debut_activite'),
      date_cessation_activite: value_or_placeholder('ent_act_date_cessation_activite'),
      date_cloture_liquidation: value_or_placeholder('ent_act_date_cloture_liquidation'),
      date_transfert_patrimoine: value_or_placeholder('ent_act_date_transfert_patrimoine'),
      date_dissolution: value_or_placeholder('ent_act_date_dissolution')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def code_nafa_payload
    {
<<<<<<< HEAD
      code_nafa_principal:   json_body['ent_act_code_nafa_principal'],
      code_nafa_secondaire1: json_body['ent_act_code_nafa_secondaire_1'],
      code_nafa_secondaire2: json_body['ent_act_code_nafa_secondaire_2'],
      code_nafa_secondaire3: json_body['ent_act_code_nafa_secondaire_3'],
      code_nafa_libelle:     json_body['gest_libelle_code_nafa'],
=======
      code_nafa_principal: value_or_placeholder('ent_act_code_nafa_principal'),
      code_nafa_secondaire1: value_or_placeholder('ent_act_code_nafa_secondaire_1'),
      code_nafa_secondaire2: value_or_placeholder('ent_act_code_nafa_secondaire_2'),
      code_nafa_secondaire3: value_or_placeholder('ent_act_code_nafa_secondaire_3'),
      code_nafa_libelle: value_or_placeholder('gest_libelle_code_nafa')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def secteur_activite_nar_payload
    {
<<<<<<< HEAD
      secteur_activite_intitule_nar_4:  json_body['gest_nar_4'],
      secteur_activite_intitule_nar_20: json_body['gest_nar_20'],
=======
      secteur_activite_intitule_nar_4: value_or_placeholder('gest_nar_4'),
      secteur_activite_intitule_nar_20: value_or_placeholder('gest_nar_20')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def forme_juridique_payload
    {
<<<<<<< HEAD
      forme_juridique_id:    json_body['ent_act_forme_juridique'],
      forme_juridique_label: json_body['gest_label_forme_juridique'],
=======
      forme_juridique_id: value_or_placeholder('ent_act_forme_juridique'),
      forme_juridique_label: value_or_placeholder('gest_label_forme_juridique')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end

  def eirl_payload
    {
<<<<<<< HEAD
      eirl_id_registre:    json_body['eirl_denomination'],
      eirl_denomination:   json_body['eirl_init_nom_registre'],
      eirl_objet_activite: json_body['eirl_objet_dap'],
      eirl_date_depot:     json_body['eirl_date_depot'],
=======
      eirl_id_registre: value_or_placeholder('eirl_denomination'),
      eirl_denomination: value_or_placeholder('eirl_init_nom_registre'),
      eirl_objet_activite: value_or_placeholder('eirl_objet_dap'),
      eirl_date_depot: value_or_placeholder('eirl_date_depot')
>>>>>>> 45eaecc1 (Autocorrect rubocop)
    }
  end
end

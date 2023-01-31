# rubocop:disable Metrics/AbcSize
class MI::Associations::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      siret:,
      adresse_siege: build_address(association[:coordonnees][:adresse_siege]),
      adresse_gestion: build_address(association[:coordonnees][:adresse_gestion]),
      telephone: association[:coordonnees][:telephone],
      courriel: association[:coordonnees][:courriel],
      site_web: association[:coordonnees][:site_web],
      publication_internet: association[:coordonnees][:publication_internet] == 'true',
      identite:,
      activites:,
      etablissements:,
      reseaux_affiliation:,
      composition_reseau:,
      agrements:,
      documents_rna:
    }
  end

  private

  def siret
    return unless Siret.new(context.params[:siret_or_rna]).valid?

    context.params[:siret_or_rna]
  end

  def identite
    {
      internal_id: association[:id_correspondance],
      rna: association[:identite][:id_rna],
      siren: association[:identite][:id_siren],
      ancien_id: association[:identite][:id_ex],
      nom: association[:identite][:nom],
      nom_sirene: association[:identite][:nom_sirene],
      sigle: association[:identite][:sigle],
      sigle_sirene: association[:identite][:sigle_sirene],
      reconnue_utilite_publique: association[:identite][:util_publique] == 'true',
      siret_siege: association[:identite][:id_siret_siege],
      forme_juridique: {
        code: association[:identite][:id_forme_juridique],
        libelle: association[:identite][:lib_forme_juridique]
      },
      alsace_moselle: {
        tribunal_instance: association[:identite][:tribunal_instance],
        volume: association[:identite][:volume],
        folio: association[:identite][:folio],
        date_publication_registre_association: replace_wrong_date_with_nil(association[:identite][:date_pub_registre])
      },
      regime: extract_regime(association[:identite][:regime]),
      groupement: association[:identite][:groupement],
      active: association[:identite][:active] == 'true',
      active_sirene: association[:identite][:active_sirene] == 'true',
      eligibilite_cec: association[:identite][:eligibilite_cec] == 'true',
      raison_non_eligibilite_cec: association[:identite][:raison_non_eligibilite_cec],
      impots_commerciaux: association[:identite][:impots_commerciaux] == 'true',
      date_creation_rna: replace_wrong_date_with_nil(association[:identite][:date_creat]),
      date_creation_sirene: replace_wrong_date_with_nil(association[:identite][:date_creation_sirene]),
      date_dissolution: replace_wrong_date_with_nil(association[:identite][:date_dissolution]),
      date_derniere_mise_a_jour_rna: replace_wrong_date_with_nil(association[:identite][:date_modif_rna]),
      date_derniere_mise_a_jour_sirene: replace_wrong_date_with_nil(association[:identite][:date_modif_siren]),
      date_publication_reconnue_utilite_publique: replace_wrong_date_with_nil(association[:identite][:date_publication_util_publique]),
      date_publication_journal_officiel: replace_wrong_date_with_nil(association[:identite][:date_pub_jo])
    }
  end

  def activites
    {
      objet: association[:activites][:objet],
      objet_social1: {
        code: association[:activites][:id_objet_social1],
        libelle: association[:activites][:lib_objet_social1]
      },
      objet_social2: {
        code: association[:activites][:id_objet_social2],
        libelle: association[:activites][:lib_objet_social2]
      },
      champ_action_territorial: association[:activites][:champ_action_territorial],
      activite_principale: {
        code: association[:activites][:id_activite_principale],
        libelle: association[:activites][:lib_activite_principale],
        annee: format_annee(association[:activites][:annee_activite_principale])
      },
      tranche_effectif: {
        code: association[:activites][:id_tranche_effectif],
        libelle: association[:activites][:lib_tranche_effectif],
        annee: format_annee(association[:activites][:annee_effectif_salarie_cent])
      },
      economie_sociale_et_solidaire: association[:activites][:appartenance_ess] == 'O',
      date_appartenance_ess: replace_wrong_date_with_nil(association[:activites][:date_appartenance_ess])
    }
  end

  def reseaux_affiliation
    return [] if association[:reseaux_affiliation].blank?

    Array.wrap(association[:reseaux_affiliation][:reseau_affiliation]).map do |reseau_affiliation|
      {
        nom: reseau_affiliation[:nom],
        numero: reseau_affiliation[:numero],
        rna: reseau_affiliation[:id_rna],
        siret: reseau_affiliation[:id_siret],
        objet: reseau_affiliation[:objet],
        adresse: build_address(reseau_affiliation[:adresse]),
        telephone: reseau_affiliation[:telephone],
        courriel: reseau_affiliation[:courriel],
        attestation_affiliation_url: reseau_affiliation[:url],
        nombre_licencies: {
          hommes: replace_wrong_integer_with_nil(reseau_affiliation[:nb_licencies_h]),
          femmes: replace_wrong_integer_with_nil(reseau_affiliation[:nb_licencies_f]),
          total: replace_wrong_integer_with_nil(reseau_affiliation[:nb_licencies])
        }
      }
    end
  end

  def composition_reseau
    return [] if association[:composition_reseau].blank?

    Array.wrap(association[:composition_reseau][:membre]).map do |membre_reseau|
      {
        rna: membre_reseau[:id_rna],
        siret: membre_reseau[:id_siret],
        nom: membre_reseau[:nom],
        objet: membre_reseau[:objet],
        adresse: build_address(membre_reseau[:adresse]),
        telephone: format_phone_number(membre_reseau[:telephone]),
        courriel: membre_reseau[:courriel],
        site_web: membre_reseau[:site_web]
      }
    end
  end

  def agrements
    return [] if association[:agrements].blank?

    Array.wrap(association[:agrements][:agrement]).map do |agrement|
      {
        numero: agrement[:numero],
        date_attribution: replace_wrong_date_with_nil(agrement[:date_attribution]),
        type: agrement[:type],
        niveau: agrement[:niveau],
        attributeur: agrement[:attributeur],
        url: agrement[:url]
      }
    end
  end

  def etablissements
    return [] if association[:etablissements].blank?

    Array.wrap(association[:etablissements][:etablissement]).map do |etablissement|
      {
        siren: etablissement[:id_siren],
        siret: etablissement[:id_siret],
        actif: etablissement[:actif] == 'true',
        siege: etablissement[:est_siege] == 'true',
        nom: etablissement[:nom],
        telephone: format_phone_number(etablissement[:telephone]),
        courriel: etablissement[:courriel],
        date_debut_activite: replace_wrong_date_with_nil(etablissement[:date_actif]),
        adresse: build_address(etablissement[:adresse]),
        activite_principale: {
          code: etablissement[:id_activite_principale],
          libelle: etablissement[:lib_activite_principale]
        },
        tranche_effectif: {
          code: association[:activites][:id_tranche_effectif],
          libelle: association[:activites][:lib_tranche_effectif]
        },
        representants_legaux: extract_representants_legaux(etablissement[:id_siret]),
        rhs: extract_rhs(etablissement[:id_siret]),
        comptes: extract_comptes(etablissement[:id_siret]),
        documents_dac: extract_documents_dac(etablissement[:id_siret])
      }
    end
  end

  def build_address(address)
    address ||= {}

    {
      complement: [address[:cplt_1], address[:cplt_2], address[:cplt_3]].join(' ').strip.presence,
      numero_voie: address[:num_voie].try(:strip),
      type_voie: address[:type_voie].try(:strip),
      libelle_voie: address[:voie].try(:strip),
      distribution: address[:bp].try(:strip),
      code_insee: address[:code_insee].try(:strip),
      code_postal: address[:cp].try(:strip),
      commune: address[:commune].try(:strip)
    }
  end

  def extract_representants_legaux(siret)
    extract_representants_legaux_for(siret).map do |representant_legal|
      {
        civilite: representant_legal[:civilite],
        nom: representant_legal[:nom].try(:upcase),
        prenom: representant_legal[:prenom],
        fonction: representant_legal[:fonction],
        valideur_cec: representant_legal[:valideur_cec] == 'true',
        publication_internet: representant_legal[:publication_internet] == 'true',
        telephone: format_phone_number(representant_legal[:telephone]),
        courriel: representant_legal[:courriel]
      }
    end
  end

  def extract_representants_legaux_for(siret)
    return [] if association[:representants_legaux].blank?

    Array.wrap(association[:representants_legaux][:representant_legal]).select do |representant_legal|
      representant_legal[:id_siret] == siret &&
        representant_legal[:deleted] == 'false' &&
        (representant_legal[:est_representant_legal] == 'true' || representant_legal[:est_representant_legal].nil?)
    end
  end

  def extract_rhs(siret)
    extract_rhs_for(siret).map do |rh|
      {
        annee: rh[:annee],
        nombre_benevoles: replace_wrong_integer_with_nil(rh[:nb_benevoles]),
        nombre_volontaires: replace_wrong_integer_with_nil(rh[:nb_volontaires]),
        nombre_salaries: replace_wrong_integer_with_nil(rh[:nb_salaries]),
        nombre_salaries_etpt: replace_wrong_float_with_nil(rh[:nb_salaries_etpt]),
        nombre_emplois_aides: replace_wrong_integer_with_nil(rh[:nb_emplois_aides]),
        nombre_personnels_detaches: replace_wrong_integer_with_nil(rh[:nb_personnels_detaches]),
        nombre_adherents: {
          hommes: replace_wrong_integer_with_nil(rh[:nb_adherents_h]),
          femmes: replace_wrong_integer_with_nil(rh[:nb_adherents_f]),
          total: replace_wrong_integer_with_nil(rh[:nb_adherents])
        }
      }
    end
  end

  def extract_rhs_for(siret)
    sanitized_rhs.select do |rh|
      rh[:id_siret] == siret
    end
  end

  def sanitized_rhs
    @sanitized_rhs ||= sanitized_fields(:rhs, :rh)
  end

  def extract_comptes(siret)
    extract_comptes_for(siret).map do |compte|
      {
        annee: compte[:annee],
        commisaire_aux_comptes: compte[:a_commisaire_aux_comptes] == 'true',
        montant_dons: compte[:dons].to_f,
        cause_subventions: compte[:cause_subv],
        montant_subventions: compte[:subv].to_f,
        montant_aides_sur_3ans: compte[:aides_3ans].to_f,
        total_charges: compte[:charges].to_f,
        total_resultat: compte[:resultat].to_f,
        total_produits: compte[:produits].to_f
      }
    end
  end

  def extract_comptes_for(siret)
    sanitized_comptes.select do |compte|
      compte[:id_siret] == siret
    end
  end

  def sanitized_comptes
    @sanitized_comptes ||= sanitized_fields(:comptes, :compte)
  end

  def documents_rna
    return [] if association[:documents].blank?
    return [] if association[:documents][:document_rna].blank?

    Array.wrap(association[:documents][:document_rna]).map do |document_rna|
      {
        id: document_rna[:id],
        type: document_rna[:type] == 'PIECE' ? 'Pièce' : 'Récipicé',
        sous_type: {
          code: document_rna[:sous_type],
          libelle: document_rna[:lib_sous_type]
        },
        date_depot: document_rna[:time].present? ? Time.zone.at(document_rna[:time].to_i) : nil,
        annee_depot: document_rna[:annee],
        url: document_rna[:url]
      }
    end
  end

  def extract_documents_dac(siret)
    return [] if association[:documents].blank?
    return [] if association[:documents][:document_dac].blank?

    valid_documents_for(siret).map do |document|
      {
        id: document[:uuid],
        nom: document[:nom],
        commentaire: document[:commentaire],
        type: document_dac_code_type_to_libelle(document[:meta][:type]),
        annee_validite: document[:meta][:annee_validite],
        etat: document[:meta][:etat],
        date_depot: document[:time_depot].present? ? DateTime.parse(document[:time_depot]).to_date : nil,
        url: document[:url]
      }
    end
  end

  def valid_documents_for(siret)
    Array.wrap(association[:documents][:document_dac]).select do |document|
      document[:meta][:id_siret] == siret &&
        document[:meta][:type] != 'RIB' &&
        document[:meta][:etat] != 'supprimé'
    end
  end

  def adresse_siege_raw
    @adresse_siege_raw ||= association[:coordonnees][:adresse_siege]
  end

  def association
    @association ||= xml_body_as_hash[:asso]
  end

  def document_dac_code_type_to_libelle(code_or_libelle)
    {
      'BPA' => 'Budget prévisionnel',
      'CPA' => 'Comptes du dernier exercice clôt',
      'RCA' => 'Rapport du commissaire au compte',
      'RAR' => 'Rapport d\'activité (le plus récent)',
      'RFA' => 'Rapport financier',
      'AGR' => 'Arrêté de l\'agrement',
      'AFF' => 'Attestation d’affiliation',
      'PRS' => 'Projet sportif'
    }[code_or_libelle] || code_or_libelle
  end

  def replace_wrong_date_with_nil(date)
    return if date.blank? || date == '0001-01-01'

    Date.parse(date)
  end

  def replace_wrong_integer_with_nil(integer)
    return if integer.blank?

    integer.to_i
  end

  def replace_wrong_float_with_nil(float)
    return if float.blank?

    float.to_f
  end

  def sanitized_fields(field1, field2)
    if association[field1].blank?
      []
    elsif association[field1][field2][0].is_a?(Array)
      association[field1][field2].map do |data|
        data.each_with_object({}) do |single_data, acc|
          acc[single_data.keys.first] = single_data.values.first
          acc
        end
      end
    else
      single_entry = association[field1][field2].each_with_object({}) do |single_data, acc|
        acc[single_data.keys.first] = single_data.values.first
        acc
      end

      [single_entry]
    end
  end

  def extract_regime(regime)
    case regime
    when 'alsaceMoselle'
      'Alsace-Moselle'
    when 'loi1901'
      'Loi 1901'
    when 'collectivite'
      'Collectivite'
    else
      'Autre'
    end
  end

  def format_phone_number(telephone)
    return if telephone.blank?
    return if telephone =~ /^0+$/

    telephone.gsub(/\s/, '')
  end

  def format_annee(annee)
    return if annee.blank? || annee.strip == '0'

    annee
  end
end
# rubocop:enable Metrics/AbcSize

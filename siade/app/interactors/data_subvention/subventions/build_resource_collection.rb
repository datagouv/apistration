class DataSubvention::Subventions::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    json_body['subventions']
  end

  def items_meta
    {}
  end

  def resource_attributes(item)
    result = {}

    result[:demande_subvention] = (build_application(item['application']) if item['application'])

    result[:paiements] = if item['payments']
                           build_paiements(item['payments'])
                         else
                           []
                         end

    result
  end

  def build_application(application)
    fournisseur = safe_extract(application, 'siret', 'provider')
    date_mise_a_jour = safe_extract(application, 'siret', 'last_update')

    {
      fournisseur: fournisseur,
      date_mise_a_jour_information: date_mise_a_jour,
      annee_exercice_demande: extract_value(application, 'annee_demande'),
      identifiant_engagement_juridique: extract_value(application, 'ej'),
      subvention_demandee: build_subvention_demandee(application),
      description_des_projets: build_description_projets(application),
      instruction: build_instruction(application),
      jointure_demandes_et_versements: extract_value(application, 'versementKey')
    }
  end

  def build_subvention_demandee(application)
    {
      dispositif: extract_value(application, 'dispositif'),
      sous_dispositif: extract_value(application, 'sous_dispositif'),
      montant_demande: extract_nested_value(application, %w[montants demande])
    }
  end

  def build_description_projets(application)
    result = {}

    result[:estimation_cout_total] = extract_nested_value(application, %w[montants total]) if application.dig('montants', 'total')

    result[:projet] = (application['actions_proposee'] || []).map { |action| build_projet(action) }

    result
  end

  def build_projet(action)
    {
      rang: extract_value(action, 'rang'),
      intitule: extract_value(action, 'intitule'),
      objectifs: extract_value(action, 'objectifs'),
      objectifs_operationnels: extract_value(action, 'objectifs_operationnels'),
      description: extract_value(action, 'description'),
      aide: {
        modalite: extract_value(action, 'modalite_aide'),
        nature: extract_value(action, 'nature_aide')
      },
      modalite_ou_dispositif: extract_value(action, 'modalite_ou_dispositif'),
      indicateurs: extract_value(action, 'indicateurs'),
      cofinanceurs: extract_nested_value(action, %w[cofinanceurs noms])
    }
  end

  def build_instruction(application)
    {
      service_instructeur: extract_value(application, 'service_instructeur'),
      date_commission: extract_value(application, 'date_commision'),
      statut_demande: extract_value(application, 'statut_label'),
      montant_accorde: extract_nested_value(application, %w[montants accorde])
    }
  end

  def build_paiements(paiements)
    return [] unless paiements.is_a?(Array)

    paiements.map do |paiement|
      build_paiement(paiement)
    end
  end

  def build_paiement(paiement)
    fournisseur = safe_extract(paiement, 'ej', 'provider')
    date_mise_a_jour = safe_extract(paiement, 'ej', 'last_update')

    result = {
      fournisseur: fournisseur,
      date_mise_a_jour_information: date_mise_a_jour,
      jointure_demandes_et_versements: extract_value(paiement, 'versementKey'),
      montant_verse: extract_value(paiement, 'amount'),
      date_versement: extract_value(paiement, 'dateOperation'),
      centre_financier: extract_value(paiement, 'centreFinancier'),
      domaine_fonctionnel: extract_value(paiement, 'domaineFonctionnel'),
      activitee: extract_value(paiement, 'activitee'),
      numero_bop: extract_value(paiement, 'bop')
    }

    result[:programme] = build_programme(paiement) if paiement['programme'] || paiement['libelleProgramme'] || paiement['bop']

    result
  end

  def build_programme(paiement)
    {
      numero: extract_value(paiement, 'programme'),
      libelle: extract_value(paiement, 'libelleProgramme'),
      fournisseur: safe_extract(paiement, 'programme', 'provider'),
      date_mise_a_jour_information: safe_extract(paiement, 'programme', 'last_update')
    }
  end

  def extract_value(source, key)
    return nil unless source&.dig(key)

    field = source[key]
    return nil unless field.is_a?(Hash) && field.key?('value')

    field['value']
  end

  def extract_nested_value(source, keys)
    return nil unless source

    nested_source = source.dig(*keys)
    return nil unless nested_source.is_a?(Hash) && nested_source.key?('value')

    nested_source['value']
  end

  def safe_extract(source, key, subkey)
    source&.dig(key, subkey)
  rescue StandardError
    nil
  end
end

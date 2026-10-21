class MI::SIAF::Fondations::BuildResource < BuildResource
  DOMAINES_INTERET_GENERAL = [
    'Culturel',
    "Défense de l'environnement naturel",
    'Diffusion de la culture, de la langue et des connaissances scientifiques françaises',
    'Éducatif',
    'Familial',
    'Humanitaire',
    'Mise en valeur du patrimoine artistique',
    'Scientifique',
    'Social',
    'Sportif'
  ].freeze

  DOMAINE_INTERET_GENERAL_PATTERN = /\s*((?:#{Regexp.union(DOMAINES_INTERET_GENERAL).source})(?=\s*(?:,|\z))|[^,]+)/

  def self.departements
    AppConfig.yaml_file(Rails.root.join('config/data/insee/departements.yml'))
  end

  protected

  def resource_attributes
    {
      identifiants:,
      identite:,
      activites:,
      filiation:,
      situation_financiere:
    }
  end

  private

  def identifiants
    {
      rnf: fondation['id'],
      siren: fondation['siret']&.first(9),
      siret_siege: fondation['siret']
    }
  end

  # rubocop:disable-next Metrics/AbcSize
  def identite
    {
      service_instructeur:,
      type_fondation: fondation['foundationType'],
      nom: fondation['title'],
      etat: fondation['state'],
      date_effet_etat: date(fondation['stateEffectiveAt']),
      date_creation: date(fondation['creationAt']),
      duree_determinee: fondation['dueDate'].present?,
      date_terme: date(fondation['dueDate']),
      cloture_exercice:,
      adresse_siege:,
      courriel: fondation['email'],
      telephone: fondation['phone']
    }
  end

  def service_instructeur
    {
      code: fondation['department'],
      libelle: self.class.departements[fondation['department']]
    }
  end

  def cloture_exercice
    fiscal_end_at = date(fondation['fiscalEndAt'])

    return if fiscal_end_at.nil?

    {
      mois: fiscal_end_at.month,
      jour: fiscal_end_at.day
    }
  end

  def adresse_siege
    address = fondation['address'] || {}
    ds_address = address['dsAddress'] || {}

    {
      adresse_complete: address['oneLine']&.squish,
      numero_voie: ds_address['streetNumber'],
      libelle_voie: ds_address['streetName'],
      code_insee: ds_address['cityCode'],
      code_postal: ds_address['postalCode'],
      commune: ds_address['cityName'],
      pays: ds_address['countryName']
    }
  end

  def activites
    {
      objet: fondation['socialObject'],
      domaines_interet_general:,
      activite_internationale_prevue_par_statuts: fondation['hasInternationalActivity']
    }
  end

  def domaines_interet_general
    fondation['generalInterestDomain'].to_s.scan(DOMAINE_INTERET_GENERAL_PATTERN).flatten.map(&:strip).compact_blank
  end

  def filiation
    lineage = fondation['fromLineage']

    return [] if lineage.blank?

    organismes = lineage['organismes'].presence || [{}]

    organismes.map do |organisme|
      {
        type_operation: lineage['type'],
        identifiant: organisme['publicId']
      }
    end
  end

  def situation_financiere
    {
      annees_subventions_publiques: fondation['publicSubsidyYears'] || []
    }
  end

  def date(iso8601_timestamp)
    return if iso8601_timestamp.blank?

    Date.parse(iso8601_timestamp)
  end

  def fondation
    json_body
  end
end

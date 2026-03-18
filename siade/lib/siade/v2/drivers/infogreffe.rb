class SIADE::V2::Drivers::Infogreffe < SIADE::V2::Drivers::GenericDriver
  attr_reader :siren

  default_to_nil_raw_fetching_methods :liste_observations,
                                      :mandataires_sociaux,
                                      :date_immatriculation,
                                      :date_immatriculation_timestamp,
                                      :forme_juridique,
                                      :date_radiation,
                                      :capital_social,
                                      :forme_juridique_code,
                                      :nom_commercial,
                                      :date_extrait

  def initialize(hash)
    @siren = hash[:siren]
    @placeholder_to_nil = hash.dig(:driver_infogreffe_options, :placeholder_to_nil)
  end

  def provider_name
    'Infogreffe'
  end

  def request
    @request ||= SIADE::V2::Requests::Infogreffe.new(@siren)
  end

  def check_response; end

  def entreprise_information
    @entreprise_information ||= Nokogiri.XML(response.body)
  end

  def liste_observations_raw
    entreprise_information.try(:css, 'liste_observations observation').try(:inject, []) do |liste_observations, xml_observation|
      liste_observations << observation(xml_observation)
    end
  end

  def mandataires_sociaux_raw
    entreprise_information.try(:css, 'liste_dirigeant dirigeant').try(:inject, []) do |liste_dir, xml_dirigeant|
      liste_dir << mandataire_social(xml_dirigeant)
    end
  end

  def mandataire_social(xml)
    nom = xml.css('nom').text.strip
    prenom = xml.css('prenom').text.strip
    date_naissance = xml.css('naissance date').blank? ? '' : xml.css('naissance date').attribute('dateISO').value
    date_naissance_timestamp = date_naissance.in_time_zone.to_i
    raison_sociale = xml.css('denomination').text.strip
    siren = xml.css('pm num_ident').text.strip
    type = xml.attribute('type').value
    {
      nom:                      nom,
      prenom:                   prenom,
      fonction:                 xml.css('qualite').text.strip,
      date_naissance:           date_naissance,
      date_naissance_timestamp: date_naissance_timestamp,
      dirigeant:                true,
      raison_sociale:           raison_sociale,
      identifiant:              siren,
      type:                     type
    }
  end

  def nom_commercial_raw
    nom_commercial_siege_social || nom_commercial_default
  end

  def nom_commercial_siege_social
    entreprise_information.try(:css, 'etablissement')&.find{ |e| e.attribute('type').value == '1'}.try(:css, 'nom_commercial').try(:text)
  end

  def nom_commercial_default
    entreprise_information.try(:css, 'etablissement nom_commercial').try(:text)
  end

  def capital_social_raw
    entreprise_information.try(:css, 'capital montant').try(:first).try(:[], 'valeur').try(:to_i)
  end

  def date_radiation_raw
    Date.parse(retrieve_date_radiation).in_time_zone.to_i
  rescue
    nil
  end

  def date_immatriculation_raw
    entreprise_information.css('dossier').first['dateISO_immat']
  end

  def date_immatriculation_timestamp_raw
    Date.parse(date_immatriculation).in_time_zone.to_i
  end

  def date_extrait_raw
    entreprise_information.css('dossier').first['date_extrait']
  end

  def forme_juridique_raw
    entreprise_information.try(:css, 'entreprise pm').first['forme_juridique']
  end

  def forme_juridique_code_raw
    entreprise_information.try(:css, 'entreprise pm').first['codeFormeJuridique']
  end

  def observation(xml)
    date = xml.try(:attribute, 'dateISO').try(:value)
    date_timestamp = convert_date_to_timestamp date
    {
      date:           date,
      date_timestamp: date_timestamp,
      numero:         xml.try(:attribute, 'numero').try(:value),
      libelle:        xml.try(:css, :libelle).try(:text)
    }
  end

  def convert_date_to_timestamp(date)
    Date.parse(date).in_time_zone.to_i
  rescue ArgumentError
    nil
  end
end

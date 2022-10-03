class SIADE::V2::Drivers::Exercices < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siret, :request_options

  default_to_nil_raw_fetching_methods :liste_ca

  def initialize(hash)
    @siret = hash[:siret]
    @request_options = hash[:driver_options]
  end

  def provider_name
    'DGFIP - Adélie'
  end

  def request
    @request ||= SIADE::V2::Requests::Exercices.new(siret, request_options)
  end

  def check_response; end

  def exercice_information
    @exercice_information ||= JSON.parse(response.body).deep_transform_keys(&:underscore)
  end

  def liste_ca_raw
    if exercice_information['liste_ca'].is_a? Array
      add_timestamp exercice_information['liste_ca']
    else
      add_timestamp([] << exercice_information['liste_ca'])
    end
  end

  private

  def add_timestamp(ca_liste)
    ca_liste.each do |e|
      e['date_fin_exercice_timestamp'] = date_to_timestamp(e['date_fin_exercice'])
    end
  end

  def date_to_timestamp(date)
    Date.parse(date).in_time_zone.to_i
  end
end

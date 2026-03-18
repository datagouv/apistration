class SIADE::V2::Drivers::MarquesINPI < SIADE::V2::Drivers::GenericDriver
  attr_reader :siren

  default_to_nil_raw_fetching_methods :count, :latests_marques

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'INPI'
  end

  def request
    @request ||= SIADE::V2::Requests::MarquesINPI.new(siren)
  end

  def check_response
    if request.errors.blank?
      begin
        parse_marques_information
      rescue
        Rails.logger.error
        set_error_message_for 502
      end
    end
  end

  protected

  def count_raw
    marques_information['metadata']['count']
  end

  def latests_marques_raw
    latests_marques_raw = marques_information['results'].take(5)
    latests_marques_raw.map do |marque_raw|
      marque_hash = {}

      marque_raw_hash_interesting_keys_with_readable_names.each do |interesting_key, readable_key|
        marque_hash_raw = marque_fields_raw_into_hash(marque_raw['fields'])
        marque_hash[readable_key] = marque_hash_raw[interesting_key]
      end

      marque_hash
    end
  end

  def marque_fields_raw_into_hash(fields)
    fields.map { |f| [f['name'], (f['value'] || f['values'])]  }.to_h
  end

  def marque_raw_hash_interesting_keys_with_readable_names
    [
      ["ApplicationNumber"          , "numero_identification"],
      ["Mark"                       , "marque"],
      ["MarkCurrentStatusCode"      , "marque_status"],
      ["DEPOSANT"                   , "depositaire"],
      ["ukey"                       , "cle"]
    ]
  end

  def parse_marques_information
    @marques_information ||= JSON.parse(response.body)
  end

  def marques_information
    @marques_information || parse_marques_information
  end

  def set_error_message_502
    (@errors ||= []) << INPIError.new(:incorrect_marques_json)
  end
end

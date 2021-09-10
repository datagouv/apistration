class SIADE::V2::Drivers::ModelesINPI < SIADE::V2::Drivers::GenericDriver
  attr_reader :siren

  default_to_nil_raw_fetching_methods :count, :latests_modeles

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'INPI'
  end

  def request
    @request ||= SIADE::V2::Requests::ModelesINPI.new(@siren)
  end

  def check_response
    if request.errors.blank?
      begin
        parse_modeles_information
      rescue StandardError
        Rails.logger.error
        set_error_message_for(502)
      end
    end
  end

  protected

  def count_raw
    modeles_information['metadata']['count']
  end

  def latests_modeles_raw
    latests_modeles_raw = modeles_information['results'].take(5)
    latests_modeles_raw.map do |brevet_raw|
      brevet_hash = {}

      brevet_raw_hash_interesting_keys_with_readable_names.each do |interesting_key, readable_key|
        brevet_hash_raw = brevet_fields_raw_into_hash(brevet_raw['fields'])
        brevet_hash[readable_key] = brevet_hash_raw[interesting_key]
      end

      brevet_hash
    end
  end

  def brevet_fields_raw_into_hash(fields)
    fields.map { |f| [f['name'], (f['value'] || f['values'])] }.to_h
  end

  def brevet_raw_hash_interesting_keys_with_readable_names
    [
      %w[DesignTitle titre],
      %w[PublicationDate date_publication],
      %w[DesignApplicationDate date_depot],
      %w[DesignApplicationNumber numero_identification]
    ]
  end

  def parse_modeles_information
    @modeles_information ||= JSON.parse(response.body)
  end

  def modeles_information
    @modeles_information || parse_modeles_information
  end

  def set_error_message_502
    (@errors ||= []) << INPIError.new(:incorrect_modeles_json)
  end
end

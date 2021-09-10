class SIADE::V2::Drivers::BrevetsINPI < SIADE::V2::Drivers::GenericDriver
  attr_reader :siren

  default_to_nil_raw_fetching_methods :count, :latests_brevets

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'INPI'
  end

  def request
    @request ||= SIADE::V2::Requests::BrevetsINPI.new(@siren)
  end

  def check_response
    if request.errors.blank?
      begin
        parse_brevets_information
      rescue StandardError
        Rails.logger.error
        set_error_message_for(502)
      end
    end
  end

  protected

  def count_raw
    brevets_information['metadata']['count']
  end

  def latests_brevets_raw
    latests_brevets_raw = brevets_information['results'].take(5)
    latests_brevets_raw.map do |brevet_raw|
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
      %w[TIT titre],
      %w[PUBD date_publication],
      %w[DEPD date_depot],
      %w[PUBN numero_publication]
    ]
  end

  def parse_brevets_information
    @brevets_information ||= JSON.parse(response.body)
  end

  def brevets_information
    @brevets_information || parse_brevets_information
  end

  def set_error_message_502
    (@errors ||= []) << INPIError.new(:incorrect_brevets_json)
  end
end

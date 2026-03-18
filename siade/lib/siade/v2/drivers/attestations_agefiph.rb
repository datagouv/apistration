class SIADE::V2::Drivers::AttestationsAGEFIPH < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siret
  attr_reader :http_code,
    :bad_gateway

  def initialize(hash)
    @siret = hash[:siret]
  end

  def provider_name
    'Agefiph'
  end

  def perform_request
    if valid?
      retrieve_data_from_agefiph_microservice!

      check_response
    else
      set_error_message_for(422)
    end

    self
  end

  def dump_date
    @dump_date ||= agefiph_microservice_response_as_json['dump_date']
  end

  def derniere_annee_de_conformite_connue
    @derniere_annee_de_conformite_connue ||= agefiph_microservice_response_as_json['derniere_annee_de_conformite_connue']
  end

  private

  def valid?
    Siret.new(siret).valid?
  end

  def check_response
    if siret_found_in_agefiph_microservice?
      @http_code = 200
    elsif bad_gateway
      set_error_message_for(502)
    else
      set_error_message_for(404)
    end
  end

  def siret_found_in_agefiph_microservice?
    agefiph_microservice_response_status_ok? &&
      !derniere_annee_de_conformite_connue.nil?
  end

  def retrieve_data_from_agefiph_microservice!
    derniere_annee_de_conformite_connue
    dump_date
  end

  def agefiph_microservice_response_status_ok?
    agefiph_microservice_response.code == '200'
  end

  def agefiph_microservice_response_as_json
    @agefiph_microservice_response_as_json ||= begin
      JSON.parse(agefiph_microservice_response.body)
    rescue JSON::ParserError
      @bad_gateway = true
      {}
    end
  end

  def agefiph_microservice_response
    @agefiph_microservice_response ||= Net::HTTP.get_response(URI(agefiph_microservice_url))
  end

  def agefiph_microservice_url
    "http://127.0.0.1/agefiph/sirets/#{siret}"
  end

  def set_error_message_422
    set_error_for_bad_siret
  end
end

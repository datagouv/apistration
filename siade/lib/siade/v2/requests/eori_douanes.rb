##
# There is an UE service to check EORI existence
# https://ec.europa.eu/taxation_customs/dds2/eos/eori_validation.jsp?Lang=fr
#
# our IPs are whitelisted by their service
#
# `client_id` not set will result in a silent 404
# instead of a 400 according to their documentation
# P.S: nil `client_id` returns a 403

class SIADE::V2::Requests::EORIDouanes < SIADE::V2::Requests::Generic
  attr_accessor :eori, :siret

  def initialize(eori:)
    @eori = eori
    @siret = eori.slice /\d+/
  end

  def valid?
    if valid_eori?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'Douanes'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::EORIDouanes
  end

  def request_uri
    URI("#{url}/#{eori}")
  end

  def request_params
    {
      idClient: client_id
    }
  end

  def client_id
    Siade.credentials[:douanes_client_id]
  end

  def url
    Siade.credentials[:douanes_domain]
  end

  def net_http_options
    {
      use_ssl:     true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end

  def valid_eori?
    french_eori? || european_eori?
  end

  def french_eori?
    starts_with_FR? && siret_valid?
  end

  def european_eori?
    starts_with_2_letters? && !starts_with_FR?
  end

  def starts_with_FR?
    eori =~ /\AFR/
  end

  def starts_with_2_letters?
    eori =~ /\A[A-Z]{2}/
  end

  def siret_valid?
    Siret.new(siret).valid?
  end

  def set_error_message_422
    (@errors ||= []) << UnprocessableEntityError.new(:siret_or_eori)
  end

  def build_response
    case @raw_response
    when Net::HTTPNotFound, Net::HTTPBadRequest, Net::HTTPForbidden
      response_wrapper.new(raw_response)
    else
      super
    end
  end
end

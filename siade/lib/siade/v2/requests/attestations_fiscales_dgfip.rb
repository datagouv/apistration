class SIADE::V2::Requests::AttestationsFiscalesDGFIP < SIADE::V2::Requests::Generic
  include ActiveModel::Model

  attr_accessor :siren, :siren_is, :siren_tva, :cookie, :informations

  def initialize(*params)
    super
  end

  def valid?
    valid_siren? && valid_siren_is? && valid_siren_tva? && valid_information? && valid_cookie?
  end

  protected

  def provider_name
    'DGFIP'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def build_response
    response_wrapper.new(raw_response)
  end

  def response_wrapper
    SIADE::V2::Responses::AttestationsFiscalesDGFIP
  end

  def request_uri
    URI(Siade.credentials[:dgfip_attestations_fiscales_url])
  end

  def request_params
    informations.to_hash
  end

  def headers(request)
    request['Accept'] = 'application/pdf'
    request['Cookie'] = cookie
  end

  # DGFIP doesn't support normal encoding : %20 in querystring -> code 401 unauthorized
  # So we replace whitespace by +, when the pdf is generated, + are replaced by whitespaces
  def encode_request_params
    request_params.to_query.tr(' ', '+')
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  private

  def valid_siren?
    is_valid_siren = Siren.new(siren).valid?
    set_error_message_siren unless is_valid_siren
    is_valid_siren
  end

  def valid_siren_is?
    is_valid_siren_is = siren_is.nil? || Siren.new(siren_is).valid?
    set_error_message_siren_is unless is_valid_siren_is
    is_valid_siren_is
  end

  def valid_siren_tva?
    is_valid_siren_tva = siren_tva.nil? || Siren.new(siren_tva).valid?
    set_error_message_siren_tva unless is_valid_siren_tva
    is_valid_siren_tva
  end

  def valid_information?
    is_valid_information = !informations.nil? && informations.valid?
    set_error_message_interne unless is_valid_information
    is_valid_information
  end

  def valid_cookie?
    is_valid_cookie = cookie.nil? || !!(cookie =~ %r{^lemondgfip=.{65}; domain=.dgfip.finances.gouv.fr; path=/})
    set_error_message_cookie unless is_valid_cookie
    is_valid_cookie
  end

  def set_error_message_siren
    (@errors ||= []) << UnprocessableEntityError.new(:siren)
    @http_code = 422
  end

  def set_error_message_siren_is
    (@errors ||= []) << UnprocessableEntityError.new(:siren_is)
    @http_code = 422
  end

  def set_error_message_siren_tva
    (@errors ||= []) << UnprocessableEntityError.new(:siren_tva)
    @http_code = 422
  end

  def set_error_message_interne
    informations.errors.messages.values.flatten.each do |error|
      (@errors ||= []) << DGFIPEntrepriseUnprocessableEntityError.new(error)
    end

    @http_code = 422
  end

  def set_error_message_cookie
    (@errors ||= []) << ProviderAuthenticationError.new(provider_name)

    @http_code = 502
  end
end

class SIADE::V2::Requests::AttestationsSocialesACOSS < SIADE::V2::Requests::Generic
  attr_accessor :siren, :type_attestation, :tries

  def initialize(params)
    @siren = params[:siren]
    @type_attestation = params.dig(:type_attestation) || 'AVG_UR' # default value
    @user_id = params[:user_id] || '1'
    @recipient = params[:recipient] || '1'
  end

  def valid?
    siren_valid? &&
      type_attestation_valid? &&
      token_available?
  end

  protected

  def provider_name
    'ACOSS'
  end

  def request_lib
    :net_http
  end

  def request_verb
    :post
  end

  def build_response
    response_wrapper.new(raw_response)
  end

  def response_wrapper
    SIADE::V2::Responses::AttestationsSocialesACOSS
  end

  def request_uri
    URI("#{acoss_domain}#{acoss_path}")
  end

  def acoss_domain
    Siade.credentials[:acoss_domain]
  end

  def acoss_path
    '/attn/entreprise/v1/demandes/api_entreprise'
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def set_headers(request)
    request['Content-Type'] = 'application/json'
    request['authorization'] = "Bearer #{token}"
  end

  def post_request_body
    {
      typeAttestation: @type_attestation,
      siren: @siren,
      idClient: @user_id,
      beneficiaire: @recipient
    }.to_json
  end

  private

  def token_available?
    !!token
  end

  def token
    @token ||= SIADE::V2::OAuth2::ACOSSTokenProvider.new.token
  rescue SIADE::V2::OAuth2::ACOSSTokenProvider::Error => e
    @error_message = e.message
    set_error_message_for(502)
    false
  end

  def siren_valid?
    if Siren.new(siren).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  def type_attestation_valid?
    if !!(@type_attestation =~ /AVG_UR/)
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:attestation_kind)

      @http_code = 422
      false
    end
  end

  def set_error_message_502
    (@errors ||= []) << ProviderInternalServerError.new(
      provider_name,
      "L'ACOSS ne peut répondre à votre requête, réessayez ultérieurement (erreur: #{@error_message})"
    )
  end

  def set_error_message_422
    set_error_for_bad_siren
  end
end

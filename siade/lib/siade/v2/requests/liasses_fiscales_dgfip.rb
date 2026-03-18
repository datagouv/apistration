class SIADE::V2::Requests::LiassesFiscalesDGFIP < SIADE::V2::Requests::Generic
  include ActiveModel::Model

  attr_accessor :siren, :annee, :cookie, :user_id, :request_name

  def valid?
    siren_valid? && annee_valid? && cookie_valid? && user_id_valid? && request_name_valid?
  end

  protected

  def provider_name
    'DGFIP'
  end

  def request_uri
    case request_name
    when :declaration
      declaration_uri
    when :dictionary
      dictionary_uri
    end
  end

  def request_params
    case request_name
    when :declaration
      declaration_params
    when :dictionary
      dictionary_params
    end
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::LiassesFiscalesDGFIP
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def set_headers(request)
    request['Cookie'] = @cookie
  end

  # DGFIP doesn't support normal encoding : %20 in querystring -> code 401 unauthorized
  # So we replace whitespace by +, when the pdf is generated, + are replaced by whitespaces
  def encode_request_params
    request_params.to_query.tr(' ', '+')
  end

  private

  def declaration_uri
    URI(Siade.credentials[:dgfip_liasse_fiscale_declaration_url])
  end

  def dictionary_uri
    URI(Siade.credentials[:dgfip_liasse_fiscale_dictionnaire_url])
  end

  def declaration_params
    SIADE::V2::Adapters::LiassesFiscalesDGFIP.new(user_id, siren, annee).to_hash
  end

  def dictionary_params
    SIADE::V2::Adapters::LiassesFiscalesDGFIP.new(user_id, '', annee).to_hash
  end

  def siren_valid?
    if Siren.new(@siren).valid? || @request_name == :dictionary
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:siren)
      @http_code = 422
      false
    end
  end

  def annee_valid?
    # no easy way to test if it is an integer...
    if @annee.to_i.to_s == @annee.to_s
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:year)
      @http_code = 422
      false
    end
  end

  def cookie_valid?
    if @cookie =~ %r{^lemondgfip=.+_.+; domain=\.dgfip\.finances\.gouv\.fr; path=\/$}
      true
    else
      (@errors ||= []) << cookie_error
      @http_code = 502
      false
    end
  end

  def cookie_error
    ProviderAuthenticationError.new('DGFIP')
  end

  def user_id_valid?
    if @user_id =~ /\A([^@\s]+_at_(?:[-a-z0-9]+.)+[a-z]{2,}.\w+)|(\A[a-f0-9_]+)\z/i
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:user_id)
      @http_code = 422
      false
    end
  end

  def request_name_valid?
    if [:declaration, :dictionary].include?(@request_name)
      true
    else
      (@errors ||= []) << UnprocessableEntityError.new(:request_name)
      @http_code = 422
      false
    end
  end
end

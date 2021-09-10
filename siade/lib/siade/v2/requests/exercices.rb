class SIADE::V2::Requests::Exercices < SIADE::V2::Requests::Generic
  attr_reader :siret, :cookie, :user_id

  def initialize(siret, options)
    @siret = siret
    @cookie = options[:cookie]
    @user_id = options[:user_id]
  end

  def valid?
    if Siret.new(siret).valid?
      true
    else
      set_error_message_for 422
      false
    end
  end

  protected

  def provider_name
    'DGFIP'
  end

  def request_uri
    URI(Siade.credentials[:dgfip_chiffres_affaires_url])
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::Exercices
  end

  def follow_redirect(moved_response)
    target_uri = extract_uri_from_location(moved_response['Location'])

    if target_uri == current_uri
      response_wrapper.new(moved_response)
    else
      super(moved_response)
    end
  end

  def set_headers(request)
    request['Cookie'] = cookie
  end

  def request_params
    {
      userId: user_id,
      siret: siret
    }
  end

  def net_http_options
    { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
  end

  def set_error_message_422
    set_error_for_bad_siret
  end

  def extract_uri_from_location(new_location)
    new_location_uri = URI(new_location)
    encoded_target_uri = CGI.parse(new_location_uri.query)['url'].first
    Base64.decode64(encoded_target_uri)
  end

  def current_uri
    current_request = Net::HTTP::Get.new(build_request)
    current_request.uri.to_s
  end
end

class SIADE::V2::Requests::Associations < SIADE::V2::Requests::Generic
  attr_accessor :association_id

  def initialize(association_id)
    @association_id = association_id
  end

  def valid?
    if Siret.new(@association_id).valid? || RNAId.new(@association_id).valid?
      true
    else
      set_error_message_for(422)
      false
    end
  end

  protected

  def provider_name
    'RNA'
  end

  def request_uri
    URI("#{mi_domain}/apim/api-asso-partenaires/api/structure/#{@association_id}")
  end

  def request_params
    { proxy_only: true }
  end

  def net_http_options
    {
      use_ssl: true,
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
  end

  def request_lib
    :net_http
  end

  def request_verb
    :get
  end

  def response_wrapper
    SIADE::V2::Responses::Associations
  end

  def set_headers(request)
    super
    request['X-Gravitee-Api-Key'] = mi_gravitee_api_key
  end

  private

  def mi_domain
    Siade.credentials[:mi_domain]
  end

  def mi_gravitee_api_key
    Siade.credentials[:mi_gravitee_api_key]
  end

  def set_error_message_422
    (@errors ||= []) << UnprocessableEntityError.new(:siret_or_rna)
  end
end

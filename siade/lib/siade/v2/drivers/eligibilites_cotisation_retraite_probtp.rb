class SIADE::V2::Drivers::EligibilitesCotisationRetraitePROBTP < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret

  default_to_nil_raw_fetching_methods :eligible?, :message

  def initialize(hash)
    @siret = hash[:siret]
  end

  def provider_name
    'ProBTP'
  end

  def request
    @request ||= SIADE::V2::Requests::EligibilitesCotisationRetraitePROBTP.new(@siret)
  end

  def check_response; end

  def provider_error_custom_code
    internal_code
  end

  protected

  def body
    @body ||= JSON.parse(response.body, symbolize_names: true)
  end

  def eligible_raw
    case corps
    when '00 Compte éligible pour attestation de cotisation'
      true
    when '01 Compte non éligible pour attestation de cotisation'
      false
    else
      log_provider_error
      false
    end
  end

  def message_raw
    if success?
      corps
    else
      error_message
    end
  end

  def corps
    body.dig(:corps)
  end

  def internal_code
    body.dig(:entete, :code)
  end

  def error_message
    body.dig(:entete, :message)
  end

  def success?
    internal_code == '0'
  end

  def log_provider_error
    @provider_error_custom_code = internal_code

    MonitoringService.instance.track_provider_error(
      self,
      {
        internal_code: internal_code,
        error_message: error_message,
        corps:         corps,
      }
    )
  end
end

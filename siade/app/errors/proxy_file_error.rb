class ProxyFileError < AbstractSpecificProviderError
  HANDLED_STATUS_CODES = {
    '403' => :forbidden,
    '429' => :too_many_requests,
    '500' => :internal_error,
    '502' => :bad_gateway,
    '503' => :service_unavailable,
    '504' => :gateway_timeout
  }.freeze

  def self.from_http_status(status_code, url: nil)
    kind = HANDLED_STATUS_CODES[status_code]
    return nil unless kind

    new(kind, url:)
  end

  def initialize(kind, url: nil)
    super(kind)
    @url = url
  end

  def http_status
    :bad_gateway
  end

  def provider_name
    'DINUM'
  end

  def provider_code
    '00'
  end

  def subcode_config
    {
      forbidden: '601',
      too_many_requests: '602',
      internal_error: '603',
      bad_gateway: '604',
      service_unavailable: '605',
      gateway_timeout: '606'
    }
  end
end

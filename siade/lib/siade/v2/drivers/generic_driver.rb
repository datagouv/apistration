class SIADE::V2::Drivers::GenericDriver
  extend Forwardable
  include SIADE::V2::Utilities::UnprocessableEntityHelpers

  attr_accessor :placeholder_to_nil

  def provider_name
    fail 'should implement provider_name for errors management'
  end

  def request
    fail 'should implement request which contains the following methods : response, errors, http_code, perform'
  end

  def check_response
    fail 'should implement check_response for post-request checks'
  end

  def perform_request
    request.perform
    check_response
    self
  end

  def response
    @response ||= request.response
  end

  def errors
    @errors || request.errors
  end

  def http_code
    @http_code || request.http_code
  end

  def success?
    http_code == 200
  end

  def self.default_to_nil_raw_fetching_methods(*methods)
    methods.each do |method|
      default_to_nil_raw_fetching_method(method)
    end
  end

  def self.default_to_nil_raw_fetching_method(method)
    define_method(method) do
      default_to_nil(method) do
        send("#{method.to_s.sub('?', '')}_raw")
      end
    end
  end

  protected

  def placeholder
    'Donnée indisponible'
  end

  def default_to_nil(method = nil)
    yield
  rescue StandardError => e
    track_missing_data(method, e)
    set_partial_content_error!(method) if success?
    placeholder_to_nil ? nil : placeholder
  end

  def value_or_placeholder(key, data_hash = nil)
    data_source = data_hash || response_json
    if data_source.key?(key)
      data_source[key]
    else
      track_missing_data(key, build_exception_error(key, caller))
      set_partial_content_error!(key) if success?
      placeholder
    end
  end

  def build_exception_error(key, backtrace)
    exception = ArgumentError.new("#{key} should be present in response payload")
    exception.set_backtrace(backtrace)
    exception
  end

  def response_json
    @response_json ||= JSON.parse(response.body)
  end

  def track_missing_data(method, error)
    MonitoringService.instance.track_missing_data(method, error)
  end

  def set_error_message_for(status)
    send("set_error_message_#{status}")
    @http_code = status
  end

  private

  def set_error_message_404
    (@errors ||= []) << NotFoundError.new(provider_name)
  end

  def set_error_message_502
    (@errors ||= []) << ProviderInternalServerError.new(provider_name)
  end

  def set_partial_content_error!(key)
    @http_code = 206

    (@errors ||= []) << PartialContentError.new(key, provider_name)
  end
end

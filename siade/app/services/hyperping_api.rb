require 'json'

class HyperpingAPI
  class Error < StandardError
    attr_reader :status, :body

    def initialize(status, body)
      @status = status
      @body = body
    end

    def message
      "#{status}: #{body}"
    end
  end

  # rubocop:disable Naming/AccessorMethodName
  def get_monitors
    response = http_wrapper('monitors') do |uri|
      Net::HTTP::Get.new(uri)
    end

    handle_response(response)
  end
  # rubocop:enable Naming/AccessorMethodName

  def create_monitor(monitor_params)
    response = http_wrapper('monitors') do |uri|
      Net::HTTP::Post.new(uri).tap do |request|
        request.body = monitor_params.to_json
        request['Content-Type'] = 'application/json'
      end
    end

    handle_response(response)
  end

  def update_monitor(monitor_id, monitor_params)
    response = http_wrapper("monitors/#{monitor_id}") do |uri|
      Net::HTTP::Put.new(uri).tap do |request|
        request.body = monitor_params.to_json
        request['Content-Type'] = 'application/json'
      end
    end

    handle_response(response)
  end

  private

  def http_wrapper(path, &block)
    uri = URI.parse("#{base_url}/#{path}")

    Net::HTTP.start(uri.host, uri.port, {
      use_ssl: true,
      open_timeout: 5,
      read_timeout: 5
    }) do |http|
      request = block.call(uri)

      request['Authorization'] = "Bearer #{api_key}"

      http.request(request)
    end
  end

  def handle_response(response)
    return JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)

    raise Error.new(response.code, response.body)
  end

  def base_url
    'https://api.hyperping.io/v1'
  end

  def api_key
    Siade.credentials[:hyperping_api_key]
  end
end

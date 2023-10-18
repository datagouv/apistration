require 'json'

class HyperpingAPI
  # rubocop:disable Naming/AccessorMethodName
  def get_monitors
    response = http_wrapper('monitors') do |uri|
      Net::HTTP::Get.new(uri)
    end

    JSON.parse(response.body)
  end
  # rubocop:enable Naming/AccessorMethodName

  def create_monitor(monitor_params)
    response = http_wrapper('monitors') do |uri|
      Net::HTTP::Post.new(uri).tap do |request|
        request.body = monitor_params.to_json
        request['Content-Type'] = 'application/json'
      end
    end

    JSON.parse(response.body)
  end

  def update_monitor(monitor_id, monitor_params)
    response = http_wrapper("monitors/#{monitor_id}") do |uri|
      Net::HTTP::Put.new(uri).tap do |request|
        request.body = monitor_params.to_json
        request['Content-Type'] = 'application/json'
      end
    end

    JSON.parse(response.body)
  end

  private

  def http_wrapper(path, &block)
    uri = URI.parse("#{base_url}/#{path}")

    Net::HTTP.start(uri.host, uri.port, { use_ssl: true }) do |http|
      request = block.call(uri)

      request['Authorization'] = "Bearer #{api_key}"

      http.request(request)
    end
  end

  def base_url
    'https://api.hyperping.io/api/v1'
  end

  def api_key
    Siade.credentials[:hyperping_api_key]
  end
end

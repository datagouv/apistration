module AidesCovidRequestsHelper
  def render_aides_covid_data(endpoint_uri)
    retryable_on_aides_covid_localhost do
      localhost_response = make_aides_covid_call(endpoint_uri)

      render json:   localhost_response.body,
        status: localhost_response.code
    end
  end

  def retryable_on_aides_covid_localhost(&block)
    Retryable.retryable(tries: 3, sleep: 0, on: Net::OpenTimeout) do
      block.call
    rescue Net::OpenTimeout, Net::ReadTimeout
      error = AidesCovidTimeoutError.new

      render error_json(error, status: 502)
    end
  end

  def make_aides_covid_call(endpoint_uri)
    localhost_response = nil

    Net::HTTP.start(endpoint_uri.hostname, endpoint_uri.port) do |http|
      http.open_timeout = 1
      http.read_timeout = 1
      localhost_response = http.request_get(endpoint_uri.request_uri)
    end

    localhost_response
  end

  def render_errors
    render json:   ErrorsSerializer.new(@errors, format: error_format).as_json,
      status: :unprocessable_entity
  end

  def success?
    @errors.empty?
  end
end

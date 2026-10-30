class PingProbe
  def initialize(url, open_timeout:, read_timeout:)
    @uri = URI(url)
    @open_timeout = open_timeout
    @read_timeout = read_timeout
  end

  def perform
    Net::HTTP.start(
      @uri.host,
      @uri.port,
      use_ssl: @uri.scheme == 'https',
      open_timeout: @open_timeout,
      read_timeout: @read_timeout
    ) { |http| http.get(@uri.request_uri) }
  rescue StandardError
    nil
  end
end

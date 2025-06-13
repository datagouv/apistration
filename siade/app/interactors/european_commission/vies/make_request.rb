class EuropeanCommission::VIES::MakeRequest < MakeRequest::Get
  protected

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def api_call
    Net::HTTP.start(request_uri.host, request_uri.port, http_options.merge(extra_http_start_options)) do |http|
      request = Net::HTTP::Get.new(build_request)

      begin
        body = ''

        http.request(request) do |response|
          response.read_body do |chunk|
            body = chunk
          end
        end
      rescue OpenSSL::SSL::SSLError => e
        raise unless e.message == 'SSL_read: unexpected eof while reading'

        track_ssl_error
      ensure
        # rubocop:disable Style/OpenStructUse
        context.response = OpenStruct.new(body:, code: '200')
        # rubocop:enable Style/OpenStructUse
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def request_uri
    URI(european_commission_url)
  end

  def request_params
    {}
  end

  private

  def european_commission_url
    "#{Siade.credentials[:european_commission_vies_url]}/#{tva_number_without_fr}"
  end

  def tva_number_without_fr
    tva_number[2..]
  end

  def tva_number
    context.tva_number
  end

  def track_ssl_error
    MonitoringService.instance.track(
      'info',
      'EuropeanCommission::VIES: ssl error'
    )
  end
end

require 'open-uri'

class APIEntreprise::ProxiedFilesController < ApplicationController
  def show
    url = ProxiedFileService.get(params[:uuid])

    if url
      render_file(url)
    else
      head :not_found
    end
  rescue OpenURI::HTTPError => e
    handle_http_error(e, url)
  rescue ProxiedFileService::ConnectionError
    head :service_unavailable
  end

  private

  def render_file(url)
    file = URI.parse(url).open

    send_data file.binmode.read,
      filename: extract_filename(file, url),
      type: file.content_type
  end

  def extract_filename(file, url)
    content_disposition = file.meta['content-disposition']

    if content_disposition&.include?('filename=')
      content_disposition.match(/filename=("?)(.+)\1/)[2]
    else
      extract_filename_from_url(url)
    end
  end

  def handle_http_error(exception, url)
    case exception.io.status[0]
    when '404'
      head :not_found
    when '504'
      track_invalid_proxied_file('504', url)

      head :bad_gateway
    else
      raise exception
    end
  end

  def track_invalid_proxied_file(status, url)
    MonitoringService.instance.track_with_added_context('info', 'Proxied file error', { status:, url: })
  end

  def extract_filename_from_url(url)
    File.basename(URI.parse(url).path)
  end
end

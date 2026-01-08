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
    status_code = exception.io.status[0]

    return head(:not_found) if status_code == '404'

    error = ProxyFileError.from_http_status(status_code, url:)
    raise exception unless error

    track_invalid_proxied_file(error, status_code, url)
    render json: { errors: [error.to_h] }, status: error.http_status
  end

  def track_invalid_proxied_file(error, status, url)
    MonitoringService.instance.track_with_added_context('info', 'Proxied file error', { code: error.code, status:, url: })
  end

  def extract_filename_from_url(url)
    File.basename(URI.parse(url).path)
  end
end

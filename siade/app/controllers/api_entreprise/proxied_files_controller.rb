require 'open-uri'

class APIEntreprise::ProxiedFilesController < ApplicationController
  def show
    url = ProxiedFileService.get(params[:uuid])

    if url
      file = URI.parse(url).open

      send_data file.binmode.read, filename: extract_filename(file, url), type: file.content_type
    else
      head :not_found
    end
  end

  private

  def extract_filename(file, url)
    content_disposition = file.meta['content-disposition']

    if content_disposition&.include?('filename=')
      content_disposition.match(/filename=("?)(.+)\1/)[2]
    else
      extract_filename_from_url(url)
    end
  end

  def extract_filename_from_url(url)
    File.basename(URI.parse(url).path)
  end
end

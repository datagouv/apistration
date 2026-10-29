require 'open-uri'

class RetrieverDocumentPingDriver < RetrieverPingDriver
  def perform
    if success? && documents_downloadable?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def documents_downloadable?
    document_urls_by_kind.any? &&
      document_urls_by_kind.all? { |url| downloadable?(url) }
  rescue StandardError
    false
  end

  def downloadable?(url)
    URI.parse(url).open { |file| file.read.present? }
  end

  def document_urls_by_kind
    @document_urls_by_kind ||= retriever_call.bundled_data.data
      .filter_map(&:url)
      .uniq { |url| File.dirname(URI.parse(url).path) }
  end
end

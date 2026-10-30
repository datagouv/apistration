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
  rescue StandardError => e
    log_failure('documents list', describe(e))
    false
  end

  def downloadable?(url)
    return true if URI.parse(url).open { |file| file.read.present? }

    log_failure(url, 'empty document')
    false
  rescue StandardError => e
    log_failure(url, describe(e))
    false
  end

  def document_urls_by_kind
    @document_urls_by_kind ||= retriever_call.bundled_data.data
      .filter_map(&:url)
      .uniq { |url| File.dirname(URI.parse(url).path) }
  end

  def log_failure(subject, reason)
    Rails.logger.warn("[#{operation_id}] Failed to download #{subject}: #{reason}")
  end

  def describe(error)
    "#{error.class}: #{error.message}"
  end
end

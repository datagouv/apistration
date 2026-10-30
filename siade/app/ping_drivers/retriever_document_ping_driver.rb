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
    @document_urls_by_kind ||= documents_by_kind.map { |documents| documents.first.url }
  end

  def documents_by_kind
    newest_first(retriever_call.bundled_data.data.select(&:url))
      .group_by { |document| File.dirname(URI.parse(document.url).path) }
      .values
  end

  def newest_first(documents)
    documents.sort_by.with_index { |document, index| [-document.timestamp.to_i, index] }
  end

  def log_failure(subject, reason)
    Rails.logger.warn("[#{operation_id}] Failed to download #{subject}: #{reason}")
  end

  def describe(error)
    "#{error.class}: #{error.message}"
  end
end

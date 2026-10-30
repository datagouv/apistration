require 'open-uri'

class RetrieverDocumentPingDriver < RetrieverPingDriver
  MAX_DOCUMENTS_TRIED_PER_KIND = 3

  def perform
    if success? && documents_downloadable?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def documents_downloadable?
    documents_by_kind.any? &&
      documents_by_kind.all? { |documents| kind_downloadable?(documents) }
  rescue StandardError => e
    log_failure('documents list', describe(e))
    false
  end

  def kind_downloadable?(documents)
    documents.first(MAX_DOCUMENTS_TRIED_PER_KIND).lazy
      .map { |document| download(document.url) }
      .find { |outcome| outcome != :missing } == :downloaded
  end

  def download(url)
    return :downloaded if URI.parse(url).open { |file| file.read.present? }

    log_failure(url, 'empty document')
    :failed
  rescue OpenURI::HTTPError => e
    log_failure(url, describe(e))
    e.io.status.first == '404' ? :missing : :failed
  rescue StandardError => e
    log_failure(url, describe(e))
    :failed
  end

  def documents_by_kind
    @documents_by_kind ||= newest_first(retriever_call.bundled_data.data.select(&:url))
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

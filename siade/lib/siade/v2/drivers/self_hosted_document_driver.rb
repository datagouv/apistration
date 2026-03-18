module SIADE::V2::Drivers::SelfHostedDocumentDriver
  def document_name
    fail 'Should implement #document_name used in SelfHostedDocumentDriver'
  end

  def document_source
    fail 'Should implement #document_source used in SelfHostedDocumentDriver'
  end

  def document_storage_method
    fail 'Should implement #document_storage_method used in SelfHostedDocumentDriver'
  end

  def document_file_type
    fail 'Should implement #document_type used in SelfHostedDocumentDriver'
  end

  def check_response
    if http_code == 200 && !store_document.success?
      @http_code = 502
      @errors ||= []
      @errors.push(*store_document_errors)
    end
  end

  def store_document
    return @store_document unless @store_document.nil?

    @store_document = document_file_type.new(document_name)
    @store_document.send(document_storage_method, document_source)
  end

  def document_url_raw
    store_document.url
  end

  def store_document_errors
    store_document.errors.map do |raw_error|
      BadFileFromProviderError.new(provider_name, raw_error[0], raw_error[1])
    end
  end
end

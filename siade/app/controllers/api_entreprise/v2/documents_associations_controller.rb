class APIEntreprise::V2::DocumentsAssociationsController < APIEntreprise::V2::BaseController
  def show
    retriever = cached_retriever || retrieve_documents_associations

    if retriever.success?
      render json: serialized_data(retriever),
        status: extract_http_code(retriever)
    else
      render json: ErrorsSerializer.new(retriever.errors, format: error_format).as_json,
        status: extract_http_code(retriever)
    end
  end

  private

  def retrieve_documents_associations
    @retrieve_documents_association ||= begin
      retriever = ::MI::Associations::Documents.call(params: retriever_params)

      write_retriever_cache(retriever) unless at_least_one_error_kind_of?(:network_error, retriever)

      retriever
    end
  end

  def serialized_data(retriever)
    {
      documents: retriever.bundled_data.data.map do |document_resource|
        {
          type: document_resource.type,
          url: document_resource.url,
          timestamp: document_resource.timestamp
        }
      end,
      nombre_documents: retriever.total_documents,
      nombre_documents_deficients: retriever.upload_errors
    }
  end

  def retriever_params
    {
      id: params.require(:id)
    }
  end

  def write_retriever_cache(retriever)
    EncryptedCache.write(cache_key, retriever, expires_in: 1.hour)
  end

  def cache_key
    request.path
  end

  def cached_retriever
    @cached_retriever ||= EncryptedCache.read(cache_key)
  end
end

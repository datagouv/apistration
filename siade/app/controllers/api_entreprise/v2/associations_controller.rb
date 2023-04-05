class APIEntreprise::V2::AssociationsController < APIEntreprise::V2::BaseController
  def show
    retriever = cached_retriever || retrieve_association

    if retriever.success?
      render json: { association: APIEntreprise::AssociationRNASerializer::V2.new(retriever).as_json }, status: retriever.http_code
    else
      render_errors(retrieve_association)
    end
  end

  private

  def association_id_from_params
    params.require(:id)
  end

  def retrieve_association
    @retrieve_association ||= begin
      retriever = SIADE::V2::Retrievers::Associations.new(association_id_from_params)

      retriever.retrieve

      write_retriever_cache(retriever) unless at_least_one_error_kind_of?(:network_error, retriever)

      retriever
    end
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

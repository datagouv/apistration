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

      write_retriever_cache(retriever, expires_in: 1.hour) unless at_least_one_error_cant_be_cached?(retriever)

      retriever
    end
  end
end

class API::V2::ExercicesController < API::V2::AbstractDGFIPController
  def show
    retriever = cached_retriever || retrieve_exercice

    if retriever.success?
      render json: ExerciceSerializer::V2.new(retriever).as_json, status: retriever.http_code
    else
      render_errors(retriever)
    end
  end

  private

  def retrieve_exercice
    @retrieve_exercice ||= begin
      retriever = SIADE::V2::Retrievers::Exercices.new(params[:siret], retriever_params(dgfip_service))
      retriever.retrieve

      Rails.cache.write(cache_key, retriever, expires_in: until_next_dgfip_update_time) unless at_least_one_error_kind_of?(:network_error, retriever)

      retriever
    end
  end

  def cached_retriever
    Rails.cache.read(cache_key)
  end

  def resource_scope
    :exercices
  end

  def retriever_params(dgfip_service)
    retriever_params = params.permit(:siret)

    retriever_params[:user_id] = UserIdDGFIPService.call(@authenticated_user.id)
    retriever_params[:cookie]  = dgfip_service.cookie

    retriever_params
  end

  def until_next_dgfip_update_time
    if (0..3).include?(now.hour)
      (now.beginning_of_day + 3.hours) - now
    else
      (now.end_of_day + 3.hours) - now
    end
  end

  def cache_key
    "api_v2_exercices_controller_#{params[:siret]}"
  end

  def now
    Time.zone.now
  end
end

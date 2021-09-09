class API::V3AndMore::MI::AssociationsController < API::V3AndMore::BaseController
  def show
    authorize :associations

    organizer = ::MI::Associations.call(params: organizer_params)

    if organizer.success?
      render json:   ::MI::Associations::V3.new(organizer.resource).serializable_hash,
             status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      id: params.require(:id),
    }
  end
end

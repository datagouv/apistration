class API::V3AndMore::MI::AssociationsController < API::V3AndMore::BaseController
  def show
    authorize :associations

    organizer = ::MI::Associations.call(params: organizer_params)

    if organizer.success?
      render json:   serializer_class.new(organizer.resource).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siret_or_rna: params.require(:siret_or_rna)
    }
  end

  def serializer_module
    ::MI::AssociationSerializer
  end
end

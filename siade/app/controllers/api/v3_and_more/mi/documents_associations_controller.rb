class API::V3AndMore::MI::DocumentsAssociationsController < API::V3AndMore::BaseController
  attr_reader :organizer

  def show
    authorize :associations

    @organizer = ::MI::Associations::Documents.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.resource_collection, options(organizer)).serializable_hash, status: extract_http_code(organizer)
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
    ::MI::DocumentAssociationSerializer
  end

  def options(organizer)
    {
      is_collection: true,
      meta: organizer.meta
    }
  end
end

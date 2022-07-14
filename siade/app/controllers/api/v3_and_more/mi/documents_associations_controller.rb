class API::V3AndMore::MI::DocumentsAssociationsController < API::V3AndMore::BaseController
  attr_reader :organizer

  def show
    authorize :associations

    @organizer = ::MI::Associations::Documents.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash, status: extract_http_code(organizer)
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
end

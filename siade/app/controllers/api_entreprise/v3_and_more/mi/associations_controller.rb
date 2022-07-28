class APIEntreprise::V3AndMore::MI::AssociationsController < APIEntreprise::V3AndMore::BaseController
  def show
    authorize :associations

    organizer = ::MI::Associations.call(params: organizer_params)

    if organizer.success?
      render json:   serializer_class.new(organizer.bundled_data).serializable_hash,
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
    ::APIEntreprise::MI::AssociationSerializer
  end
end

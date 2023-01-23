class APIEntreprise::V3AndMore::DGFIP::ChiffresAffairesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::DGFIP::ChiffresAffaires, cache: true, cache_key:)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data).serializable_hash,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: params[:siret],
      user_id: current_user.id
    }
  end

  def cache_key
    "dgfip/attestations_fiscales:siret=#{params[:siret]}"
  end

  def serializer_module
    ::APIEntreprise::DGFIP::ChiffresAffairesCollectionSerializer
  end
end

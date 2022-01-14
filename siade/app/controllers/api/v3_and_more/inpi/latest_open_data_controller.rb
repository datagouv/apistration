class API::V3AndMore::INPI::LatestOpenDataController < API::V3AndMore::BaseController
  protected

  def organizer_params
    {
      siren: params.require(:siren),
      limit: 5
    }
  end

  def options
    {
      is_collection: true,
      meta: organizer.meta
    }
  end
end

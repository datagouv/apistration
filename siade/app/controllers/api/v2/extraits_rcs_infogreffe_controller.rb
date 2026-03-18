class API::V2::ExtraitsRCSInfogreffeController < API::AuthenticateEntityController
  def show
    authorize :extraits_rcs

    retrieve_extrait_rcs = SIADE::V2::Retrievers::ExtraitsRCSInfogreffe.new(siren_from_params)
    retrieve_extrait_rcs.retrieve

    if retrieve_extrait_rcs.success?
      render json: ExtraitRCSInfogreffeSerializer::V2.new(retrieve_extrait_rcs).as_json,  status: retrieve_extrait_rcs.http_code
    else
      render_errors(retrieve_extrait_rcs)
    end
  end

  def siren_from_params
    params.require(:siren)
  end
end

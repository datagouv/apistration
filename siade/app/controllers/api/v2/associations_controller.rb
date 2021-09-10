class API::V2::AssociationsController < API::V2::BaseController
  def show
    authorize :associations

    retrieve_association = SIADE::V2::Retrievers::Associations.new(association_id_from_params)
    retrieve_association.retrieve

    if retrieve_association.success?
      render json: { association: AssociationRNASerializer::V2.new(retrieve_association).as_json }, status: retrieve_association.http_code
    else
      render_errors(retrieve_association)
    end
  end

  def association_id_from_params
    params.require(:id)
  end
end

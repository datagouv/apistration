module Admin
  class APIRequestsController < AdminController
    before_action :set_facade
    before_action :set_request_metadata_values

    def index
      @result = nil
    end

    def create
      @result = @facade.execute_request(request_params)
      render :index
    end

    private

    def set_facade
      @facade = APIRequestFacade.new(
        namespace:,
        selected_endpoint_uid: params[:endpoint_uid]
      )
    end

    def endpoint_params
      params.permit(*@facade.permitted_params).to_h
    end

    def set_request_metadata_values
      @context_value = params[:context].presence || default_context
      @object_value = default_object
    end

    def request_params
      endpoint_params.merge(
        'context' => @context_value,
        'object' => @object_value
      )
    end

    def default_context = 'Débugging'

    def default_object = "user_#{true_user.id}"
  end
end

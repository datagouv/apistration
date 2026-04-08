class API::DatapassWebhooksController < APIController
  include DatapassWebhooks

  protected

  def datapass_webhook_params
    params.permit(
      :event,
      :model_type,
      :fired_at,
      data: {}
    ).to_h.symbolize_keys
  end

  def datapass_id
    params[:data][:pass][:id]
  end

  def extract_organizer(kind)
    DatapassWebhook.const_get(kind.classify)
  end
end

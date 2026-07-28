class DatapassWebhook::APIParticulier::CreateHubEESubscription < ApplicationInteractor
  delegate :authorization_request, :hubee_organization_payload, :hubee_subscription_payload, to: :context

  def call
    context.hubee_subscription_payload = create_subscription_on_hubee
    save_hubee_subscription_id_to_authorization_request
  end

  private

  def create_subscription_on_hubee
    hubee_api_client.create_subscription(authorization_request, hubee_organization_payload, process_code)
  end

  def hubee_api_client
    @hubee_api_client ||= HubEEAPIClient.new
  end

  def process_code
    'FormulaireQF'
  end

  def save_hubee_subscription_id_to_authorization_request
    authorization_request.extra_infos['hubee_subscription_id'] = hubee_subscription_payload['id']
    authorization_request.save!
  end
end

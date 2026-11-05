module DatapassWebhooks
  extend ActiveSupport::Concern

  included do
    before_action :track_payload_through_sentry
    before_action :receive_webhook!
    before_action :set_security_event_actor
  end

  def api_entreprise
    handle_api('api_entreprise')
  end

  def api_particulier
    handle_api('api_particulier')
  end

  def api_particulier_demarche_numerique
    handle_api('api_particulier_demarche_numerique')
  end

  protected

  def datapass_webhook_params
    fail NotImplementedError
  end

  def datapass_id
    fail NotImplementedError
  end

  def extract_organizer(kind)
    fail NotImplementedError
  end

  private

  def handle_api(kind)
    result = extract_organizer(kind).call(**datapass_webhook_params)

    if result.success?
      handle_success(result)
    else
      render json: {}, status: :unprocessable_content
    end
  end

  def handle_success(result)
    if event == 'approve'
      render json: {
        token_id: result.token_id
      }.compact
    else
      render json: {}
    end
  end

  def track_payload_through_sentry
    Sentry.set_context(
      'DataPass webhook incoming payload',
      payload: {
        datapass_id:,
        event:
      }
    )
    Sentry.capture_message(
      'DataPass Incoming Payload',
      level: 'info'
    )
  end

  def event
    params[:event]
  end

  def set_security_event_actor
    SecurityEvent.assign_request_actor(SecurityEvent::DATAPASS_ACTOR)
  end

  def receive_webhook!
    result = DatapassWebhook::Receive.call(
      signature: hub_signature,
      body: request.raw_post,
      webhook_event: event,
      fired_at: params[:fired_at],
      datapass_id:
    )

    unauthorized if result.failure?
  end

  def hub_signature
    request.headers['X-Hub-Signature-256']
  end
end

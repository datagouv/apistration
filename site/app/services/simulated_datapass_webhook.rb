class SimulatedDatapassWebhook
  EVENTS = %w[submit approve refuse].freeze

  STATES = {
    'submit' => 'submitted',
    'approve' => 'validated',
    'refuse' => 'refused'
  }.freeze

  def initialize(editor_delegation_request, event)
    @editor_delegation_request = editor_delegation_request
    @authorization_request = editor_delegation_request.authorization_request
    @event = event
  end

  def payload
    {
      event: @event,
      model_type: 'authorization_request/api_entreprise',
      model_id: datapass_id,
      fired_at: Time.zone.now.to_i,
      data: {
        'id' => datapass_id,
        'public_id' => @authorization_request.public_id || SecureRandom.uuid,
        'state' => STATES.fetch(@event),
        'form_uid' => @editor_delegation_request.editor_use_case.datapass_form_uid,
        'organization' => { 'siret' => @editor_delegation_request.siret },
        'applicant' => applicant,
        'data' => @editor_delegation_request.datapass_data
      }
    }
  end

  private

  def datapass_id
    @datapass_id ||= @authorization_request.external_id || "9#{Time.zone.now.strftime('%s%L')}"
  end

  def applicant
    agent = @editor_delegation_request.submitted_by_user

    {
      'email' => agent.email,
      'given_name' => agent.first_name,
      'family_name' => agent.last_name
    }
  end
end

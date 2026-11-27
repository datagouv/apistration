# TODO: can be factorized better with previous interactor
class DatapassWebhook::FindOrCreateAuthorizationRequestModel < ApplicationInteractor
  include DatapassWebhook::PassScopes

  def call
    AuthorizationRequest.transaction { find_and_update_authorization_request }
  end

  private

  def find_and_update_authorization_request # rubocop:disable Metrics/AbcSize
    context.authorization_request = find_or_initialize_authorization_request
    context.role_changes = []

    set_reopening_event_flag

    assign_webhook_attributes

    flag_updates_as_requested if expecting_updates? && %w[submit].include?(context.event)

    return if context.authorization_request.save

    fail!('Authorization request not valid', 'error', context.authorization_request.errors.to_hash)
  end

  def find_or_initialize_authorization_request
    AuthorizationRequest.lock.find_by(external_id: datapass_id) ||
      editor_delegation_request_authorization_request_without_datapass_id ||
      AuthorizationRequest.new(external_id: datapass_id)
  end

  def editor_delegation_request_authorization_request_without_datapass_id
    editor_delegation_request_id = context.data['pass'].dig('metadata', 'editor_delegation_request_id')
    return if editor_delegation_request_id.blank?

    authorization_request = AuthorizationRequest
      .lock
      .joins(:editor_delegation_request)
      .find_by(external_id: nil, editor_delegation_requests: { id: editor_delegation_request_id })

    authorization_request&.external_id = datapass_id
    authorization_request
  end

  def datapass_id
    context.data['pass']['id']
  end

  def flag_updates_as_requested
    context.authorization_request.token.last_prolong_token_wizard.update!(status: 'updates_requested')
  end

  def expecting_updates?
    context.reopening &&
      context.authorization_request.prolong_token_expecting_updates?
  end

  def set_reopening_event_flag
    context.reopening = reopening_event?
  end

  def reopening_event?
    context.authorization_request.status == 'validated' &&
      %w[archive revoke].exclude?(context.event)
  end

  def assign_webhook_attributes
    if stale_snapshot?
      context.authorization_request.assign_attributes(missing_event_facts)
    elsif should_update_authorization_request?
      context.authorization_request.assign_attributes(authorization_request_attributes)

      create_or_update_contacts_with_roles
    end
  end

  def missing_event_facts
    authorization_request_attributes_for_current_event.select { |attribute, _| context.authorization_request.public_send(attribute).nil? }
  end

  def should_update_authorization_request?
    !context.reopening || (context.reopening && %w[transfer approve validate].include?(context.event))
  end

  def authorization_request_attributes
    datapass_attributes.merge('datapass_updated_at' => datapass_updated_at || context.authorization_request.datapass_updated_at)
  end

  def stale_snapshot?
    datapass_updated_at.present? &&
      context.authorization_request.datapass_updated_at.present? &&
      datapass_updated_at < context.authorization_request.datapass_updated_at
  end

  def datapass_updated_at
    return if context.updated_at.blank?

    @datapass_updated_at ||= Time.zone.parse(context.updated_at.to_s)
  end

  def create_or_update_contacts_with_roles
    {
      'demandeur' => 'demandeur',
      'contact_metier' => 'contact_metier',
      %w[responsable_technique contact_technique] => 'contact_technique'
    }.each do |contact_kind, role|
      contact_payload = contact_payload_for(Array(contact_kind))

      next if contact_payload.blank?

      user = extract_user_from_contact_payload(contact_payload)

      next unless user.valid?

      assign_role(role, user)
    end
  end

  def assign_role(role, user)
    user_authorization_request_role = context.authorization_request.user_authorization_request_roles.find_or_initialize_by(role:)
    previous_user = user_authorization_request_role.user
    return if previous_user == user

    user_authorization_request_role.update!(user:)
    context.role_changes << { role:, user:, previous_user: }
  end

  def extract_user_from_contact_payload(contact_payload)
    user = User.find_or_initialize_by_email(contact_payload['email'])

    user.assign_attributes(
      last_name: contact_payload['family_name'],
      first_name: contact_payload['given_name']
    )

    user
  end

  def datapass_attributes
    context.data['pass'].slice(
      'public_id',
      'intitule',
      'description',
      'demarche',
      'status',
      'siret'
    ).merge(authorization_request_attributes_for_current_event).merge(requested_scopes_attributes).merge(
      'last_update' => fired_at_as_datetime,
      'previous_external_id' => context.data['pass']['copied_from_enrollment_id'],
      'api' => context.api,
      'extra_infos' => extra_infos_with_service_provider
    )
  end

  def requested_scopes_attributes
    return {} if context.reopening

    { 'scopes' => pass_scopes }
  end

  def extra_infos_with_service_provider
    context.authorization_request.extra_infos.merge({
      'service_provider' => Hash(context.data.dig('pass', 'service_provider'))
    })
  end

  def authorization_request_attributes_for_current_event
    authorization_request_attributes_for_current_event = {}

    authorization_request_attributes_for_current_event['first_submitted_at'] = fired_at_as_datetime if context.event != 'draft' && context.authorization_request.first_submitted_at.nil?

    authorization_request_attributes_for_current_event['validated_at'] = fired_at_as_datetime if %w[approve validate].include?(context.event)

    authorization_request_attributes_for_current_event
  end

  def contact_payload_for(kinds)
    context.data['pass']['team_members'].find do |contact_payload|
      kinds.include?(contact_payload['type'])
    end
  end

  def fired_at_as_datetime
    @fired_at_as_datetime ||= Time.zone.at(context.fired_at.to_i).to_datetime
  end
end

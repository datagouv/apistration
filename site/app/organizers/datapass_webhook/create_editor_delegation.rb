class DatapassWebhook::CreateEditorDelegation < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with EditorDelegation::TrackGrant

  before do
    context.delegation_source = 'datapass_webhook'
  end

  organize DatapassWebhook::CreateEditorDelegationModel
end

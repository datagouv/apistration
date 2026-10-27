class DatapassWebhook::CreateEditorDelegation < ApplicationOrganizer
  before do
    context.delegation_source = 'datapass_webhook'
  end

  organize DatapassWebhook::CreateEditorDelegationModel,
    EditorDelegation::TrackGrant
end

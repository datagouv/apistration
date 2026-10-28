class DatapassWebhook::CreateTokenOnValidation < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackCreation

  before do
    context.token_creation_source = 'datapass_webhook'
  end

  organize DatapassWebhook::CreateTokenOnValidationModel
end

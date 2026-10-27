class DatapassWebhook::CreateOrProlongToken < ApplicationOrganizer
  include SecurityEvent::StepTracking

  tracks_with Token::TrackCreation,
    Token::TrackProlongation,
    Token::TrackScopesChange

  before do
    context.token_creation_source = 'datapass_webhook'
    context.token_prolongation_source = 'datapass_revalidation'
  end

  organize DatapassWebhook::CreateOrProlongTokenModel
end

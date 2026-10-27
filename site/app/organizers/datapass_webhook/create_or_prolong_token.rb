class DatapassWebhook::CreateOrProlongToken < ApplicationOrganizer
  before do
    context.token_creation_source = 'datapass_webhook'
  end

  organize DatapassWebhook::CreateOrProlongTokenModel,
    Token::TrackCreation
end

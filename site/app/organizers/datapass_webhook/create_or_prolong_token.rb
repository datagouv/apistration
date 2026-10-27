class DatapassWebhook::CreateOrProlongToken < ApplicationOrganizer
  before do
    context.token_creation_source = 'datapass_webhook'
    context.token_prolongation_source = 'datapass_revalidation'
  end

  organize DatapassWebhook::CreateOrProlongTokenModel,
    Token::TrackCreation,
    Token::TrackProlongation,
    Token::TrackScopesChange
end

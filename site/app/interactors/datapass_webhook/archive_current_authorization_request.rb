class DatapassWebhook::ArchiveCurrentAuthorizationRequest < ApplicationInteractor
  def call
    return unless context.event == 'archive'

    context.authorization_request.archive!
  end
end

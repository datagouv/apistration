class Token::TrackRevocations < ApplicationInteractor
  def call
    Array(context.revoked_tokens).each do |token|
      Token::TrackRevocation.call(revoked_token: token)
    end
  end
end

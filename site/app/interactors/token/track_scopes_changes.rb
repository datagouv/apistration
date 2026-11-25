class Token::TrackScopesChanges < ApplicationInteractor
  def call
    Array(context.updated_tokens).each do |token|
      Token::TrackScopesChange.call(token:)
    end
  end
end

module TokenHelpers
  def affect_scopes_to_yes_jwt_token(scopes)
    yes_jwt_token_database_model.authorization_request.update!(scopes:)
  end

  def reset_yes_jwt_token_scopes!
    yes_jwt_token_database_model.authorization_request.update!(scopes: Scope.all)
  end

  private

  def yes_jwt_token_database_model
    @yes_jwt_token_database_model ||= Token.find(seeds.yes_jwt_id)
  end

  def seeds
    @seeds ||= Seeds.new
  end
end

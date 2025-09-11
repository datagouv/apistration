class MatchIdentity::DeduceMatch < ApplicationInteractor
  def call
    context.matches = all_fields_match?

    return if context.matches

    context.fail!(message: 'Identity does not match')
  end

  private

  def all_fields_match?
    matchings = context.matchings || {}
    matchings['familyname'] &&
      matchings['givenname'] &&
      matchings['matchbirthdate']
  end
end

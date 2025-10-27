class MatchIdentity::DeduceMatch < ApplicationInteractor
  def call
    context.matches = all_fields_match?

    return if context.matches

    context.fail!(message: 'Identity does not match')
  end

  private

  def all_fields_match?
    matchings = context.matchings || {}
    # NOTE: Birthdate matching is no longer required for identity validation
    matchings['familyname'] &&
      matchings['givenname']
  end
end

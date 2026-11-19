class IdentityMatcher < ApplicationOrganizer
  organize MatchIdentity::FamilyName,
    MatchIdentity::GivenName,
    MatchIdentity::Birthdate,
    MatchIdentity::DeduceMatch
end

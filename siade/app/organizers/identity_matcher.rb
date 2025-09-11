class IdentityMatcher < ApplicationOrganizer
  organize MatchIdentity::FamilyName,
    MatchIdentity::GivenName,
    MatchIdentity::MatchBirthdate,
    MatchIdentity::DeduceMatch
end

class IdentityMatcher < ApplicationOrganizer
  organize MatchIdentity::FamilyName,
    MatchIdentity::GivenName,
    MatchIdentity::MatchSexe,
    MatchIdentity::MatchBirthdate,
    MatchIdentity::MatchCommune,
    MatchIdentity::DeduceMatch
end

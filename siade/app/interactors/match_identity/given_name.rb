class MatchIdentity::GivenName < MatchIdentity::Base
  protected

  def match?
    context.candidate_identity[:prenoms] == context.reference_identity[:prenoms]
  end
end

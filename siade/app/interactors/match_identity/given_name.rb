class MatchIdentity::GivenName < MatchIdentity::Base
  protected

  def match?
    normalize_name(context.candidate_identity[:prenoms]) ==
      normalize_name(context.reference_identity[:prenoms])
  end

  private

  def normalize_name(name)
    name.to_s.downcase.strip
  end
end

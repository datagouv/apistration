class MatchIdentity::FamilyName < MatchIdentity::Base
  include StringNormalizer

  protected

  def match?
    normalized_candidate_name == normalized_reference_name
  end

  private

  def normalized_candidate_name
    normalize_string(context.candidate_identity[:nom_naissance])
  end

  def normalized_reference_name
    normalize_string(context.reference_identity[:nom_naissance])
  end
end

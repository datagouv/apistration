class MatchIdentity::GivenName < MatchIdentity::Base
  include StringNormalizer

  protected

  def match?
    normalized_candidate_names.any? do |candidate_name|
      normalized_reference_names.any? do |reference_name|
        candidate_name == reference_name
      end
    end
  end

  private

  def normalized_candidate_names
    normalize_names(context.candidate_identity[:prenoms])
  end

  def normalized_reference_names
    normalize_names(context.reference_identity[:prenoms])
  end

  def normalize_names(names)
    Array(names).map { |name| normalize_string(name) }
  end
end

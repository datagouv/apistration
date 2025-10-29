class MatchIdentity::GivenName < MatchIdentity::Base
  include StringNormalizer

  protected

  def match?
    candidate_names.any? { |candidate_name| matches_any_reference?(candidate_name) }
  end

  private

  def matches_any_reference?(candidate_name)
    reference_names.any? do |reference_name|
      candidate_name == reference_name || reference_name.split.include?(candidate_name)
    end
  end

  def candidate_names
    Array(context.candidate_identity[:prenoms]).map { |name| normalize_string(name) }
  end

  def reference_names
    Array(context.reference_identity[:prenoms]).map { |name| normalize_string(name) }
  end
end

class ProviderUnprocessableEntityError < AbstractGenericProviderError
  SUBCODES = {
    unidentified_person: '560',
    rejected_civility: '561',
    rejected_identifier: '562',
    ambiguous_identity: '563',
    unusable_identity: '564'
  }.freeze

  def self.build_example(provider_name:, reason:, **)
    new(provider_name, reason)
  end

  attr_reader :reason

  def initialize(provider_name, reason, message = nil)
    super(provider_name, message)

    @reason = reason.to_sym
  end

  def subcode
    SUBCODES.fetch(reason) do
      raise KeyError, "#{reason} is not a valid reason name"
    end
  end

  def kind
    :wrong_parameter
  end

  def unidentified_person?
    reason == :unidentified_person
  end
end

module ValidateResponseEmissionGuard
  EMISSIONS = Hash.new { |h, k| h[k] = Set.new }
  INSTRUMENTED = Set.new

  UNIVERSAL_ERRORS = (
    RSwagCommonErrors::BASELINE_PROVIDER_ERROR_CLASSES +
    RSwagCommonErrors::BASELINE_NETWORK_ERROR_CLASSES +
    [NotFoundError]
  ).freeze

  def self.instrument(validator_class)
    return if INSTRUMENTED.include?(validator_class)

    INSTRUMENTED << validator_class

    validator_class.prepend(
      Module.new do
        define_method(:fail_with_error!) do |error|
          kind = (error.instance_variable_get(:@kind) if error.instance_variables.include?(:@kind))
          ValidateResponseEmissionGuard::EMISSIONS[self.class] << [error.class, kind]
          super(error)
        end
      end
    )
  end

  def self.verify!(validator_class) # rubocop:disable Metrics/AbcSize
    declared = ErrorRegistry
      .declarations_for(validator_class)
      .to_set { |decl| [decl.error_class, decl.options[:kind]] }

    return if declared.empty?

    emitted = EMISSIONS[validator_class]

    not_emitted = declared - emitted
    undeclared = emitted.reject { |klass, _kind| UNIVERSAL_ERRORS.include?(klass) }.to_set - declared # rubocop:disable Style/HashExcept

    failures = []
    failures << "[#{validator_class}] declared via raises but never emitted in spec: #{not_emitted.to_a.inspect}" if not_emitted.any?
    failures << "[#{validator_class}] emitted but not declared via raises (and not part of the universal baseline): #{undeclared.to_a.inspect}" if undeclared.any?

    raise failures.join("\n") if failures.any?
  end
end

RSpec.configure do |config|
  config.before(:context, type: :validate_response) do |group|
    ValidateResponseEmissionGuard.instrument(group.class.metadata[:described_class])
  end

  config.after(:context, type: :validate_response) do |group|
    ValidateResponseEmissionGuard.verify!(group.class.metadata[:described_class])
  end
end

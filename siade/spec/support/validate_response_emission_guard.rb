module ValidateResponseEmissionGuard
  EMISSIONS = Hash.new { |h, k| h[k] = Set.new }
  INSTRUMENTED = Set.new

  UNIVERSAL_ERRORS = (
    RSwagCommonErrors::BASELINE_PROVIDER_ERROR_CLASSES +
    RSwagCommonErrors::BASELINE_NETWORK_ERROR_CLASSES +
    [NotFoundError, MaintenanceError]
  ).freeze

  ERRORS_DISCRIMINATED_BY_FOREIGN_PROVIDER = [NotFoundError].freeze

  DISCRIMINANT_OPTIONS = %i[kind reason type field provider].freeze
  DISCRIMINANT_IVARS = %i[@kind @reason @type @field].freeze

  Tracker = Module.new do
    def call
      errors_before = Array(context.errors).dup

      super
    ensure
      ValidateResponseEmissionGuard.record(self.class, Array(context.errors) - errors_before, context.provider_name)
    end

    def fail_with_error!(error)
      ValidateResponseEmissionGuard.record(self.class, [error], context.provider_name)
      super
    end
  end

  def self.instrument(validator_class)
    validator_class.prepend(Tracker) if INSTRUMENTED.add?(validator_class)
  end

  def self.record(validator_class, errors, provider_name = nil)
    errors.each { |error| EMISSIONS[validator_class] << emitted_signature(error, provider_name) }
  end

  def self.verify!(validator_class)
    return unless ErrorRegistry.guarded?(validator_class)

    direct = declared_set(ErrorRegistry.direct_declarations_for(validator_class))
    inherited = declared_set(ErrorRegistry.declarations_for(validator_class))
    emitted = EMISSIONS[validator_class]
    failures = format_failures(validator_class, direct - emitted, undeclared_extras(emitted, inherited))
    raise failures.join("\n") if failures.any?
  end

  def self.emitted_signature(error, provider_name)
    [error.class, emitted_discriminant(error, provider_name)]
  end

  def self.emitted_discriminant(error, provider_name)
    return foreign_provider(error, provider_name) if ERRORS_DISCRIMINATED_BY_FOREIGN_PROVIDER.include?(error.class)

    ivar = DISCRIMINANT_IVARS.find { |name| error.instance_variable_defined?(name) }
    error.instance_variable_get(ivar) if ivar
  end

  def self.foreign_provider(error, provider_name)
    error.provider_name unless error.provider_name == provider_name
  end

  def self.declared_set(declarations)
    declarations.to_set { |decl| [decl.error_class, decl.options.values_at(*DISCRIMINANT_OPTIONS).compact.first] }
  end

  def self.undeclared_extras(emitted, declared)
    (emitted - declared).reject { |error_class, discriminant| discriminant.nil? && UNIVERSAL_ERRORS.include?(error_class) }
  end

  def self.format_failures(validator_class, missing, extra)
    failures = []
    failures << "[#{validator_class}] declared via raises but never emitted in spec: #{missing.to_a.inspect}" if missing.any?
    failures << "[#{validator_class}] emitted but not declared via raises (and not part of the universal baseline): #{extra.inspect}" if extra.any?
    failures
  end
end

RSpec.configure do |config|
  %i[validate_response validate_param_interactor].each do |type|
    config.before(:context, type:) do |group|
      ValidateResponseEmissionGuard.instrument(group.class.metadata[:described_class])
    end

    config.after(:context, type:) do |group|
      ValidateResponseEmissionGuard.verify!(group.class.metadata[:described_class])
    end
  end
end

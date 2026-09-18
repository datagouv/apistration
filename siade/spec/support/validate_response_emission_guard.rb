module ValidateResponseEmissionGuard
  EMISSIONS = Hash.new { |h, k| h[k] = Set.new }
  GROUP_EMISSIONS = Hash.new { |h, k| h[k] = Set.new }
  INSTRUMENTED = Set.new

  UNIVERSAL_ERRORS = (
    Errors::BaselineErrors::PROVIDER_ERROR_CLASSES +
    Errors::BaselineErrors::NETWORK_ERROR_CLASSES +
    [NotFoundError, MaintenanceError]
  ).freeze

  ERRORS_DISCRIMINATED_BY_FOREIGN_PROVIDER = [NotFoundError].freeze

  VALIDATOR_CLASSES = [ValidateResponse, ValidateParamInteractor].freeze

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

  def self.applies_to?(described_class)
    return false if described_class.nil?

    VALIDATOR_CLASSES.any? { |validator| described_class < validator } || ErrorRegistry.guarded?(described_class)
  end

  def self.instrument(validator_class)
    validator_class.prepend(Tracker) if INSTRUMENTED.add?(validator_class)
  end

  def self.start_group
    GROUP_EMISSIONS.clear
  end

  def self.record(validator_class, errors, provider_name = nil)
    errors.each do |error|
      signature = emitted_signature(error, provider_name)
      EMISSIONS[validator_class] << signature
      GROUP_EMISSIONS[validator_class] << signature
    end
  end

  def self.verify!(validator_class)
    return if validator_class.include?(Interactor::Organizer)
    raise "[#{validator_class}] declares neither `raises` nor `declares_no_specific_errors!`" unless ErrorRegistry.guarded?(validator_class)

    direct = declared_set(ErrorRegistry.direct_declarations_for(validator_class))
    inherited = declared_set(ErrorRegistry.declarations_for(validator_class))
    emitted = EMISSIONS[validator_class]
    failures = format_failures(validator_class, direct - exercised_in_spec(validator_class), undeclared_extras(emitted, inherited))
    raise failures.join("\n") if failures.any?
  end

  def self.exercised_in_spec(validator_class)
    GROUP_EMISSIONS
      .select { |emitter, _| emitter < validator_class }
      .values
      .reduce(EMISSIONS[validator_class], :|)
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
  config.before(:context) do |group|
    described_class = group.class.metadata[:described_class]
    next unless ValidateResponseEmissionGuard.applies_to?(described_class)

    ValidateResponseEmissionGuard.start_group
    ValidateResponseEmissionGuard.instrument(described_class)
  end

  config.after(:context) do |group|
    described_class = group.class.metadata[:described_class]
    ValidateResponseEmissionGuard.verify!(described_class) if ValidateResponseEmissionGuard.applies_to?(described_class)
  end
end

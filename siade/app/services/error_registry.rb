class ErrorRegistry
  Declaration = Data.define(:error_class, :options) do
    def build(provider_name:)
      error_class.build_example(provider_name:, **options)
    end
  end

  class << self
    def register(validator_class, error_class, **options)
      decl = Declaration.new(error_class:, options: options.freeze)
      bucket = declarations[validator_class] ||= []
      bucket << decl unless bucket.include?(decl)
      decl
    end

    def retract(validator_class, error_class, **options)
      decl = Declaration.new(error_class:, options: options.freeze)
      bucket = retractions[validator_class] ||= []
      bucket << decl unless bucket.include?(decl)
      decl
    end

    def mark_guarded(validator_class)
      declarations[validator_class] ||= []
    end

    def guarded?(validator_class)
      validator_class.ancestors.any? { |klass| declarations.key?(klass) }
    end

    def declarations_for(validator_class)
      inherited = validator_class.ancestors.flat_map { |klass| declarations.fetch(klass, []) }.uniq
      retracted = validator_class.ancestors.flat_map { |klass| retractions.fetch(klass, []) }

      inherited - retracted
    end

    def direct_declarations_for(validator_class)
      declarations.fetch(validator_class, [])
    end

    def declarations_for_organizer(organizer_class)
      flatten_chain(organizer_class).flat_map { |klass| declarations_for(klass) }.uniq
    end

    def examples_for_status(organizer_class, http_status, provider_name:)
      target = http_status.to_i

      declarations_for_organizer(organizer_class).filter_map do |decl|
        example = decl.build(provider_name:)
        next unless status_code(example) == target

        example
      end
    end

    def reset!
      @declarations = {}
      @retractions = {}
    end

    private

    def declarations
      @declarations ||= {}
    end

    def retractions
      @retractions ||= {}
    end

    def flatten_chain(klass)
      return [klass] unless klass.respond_to?(:organized) && klass.organized.any?

      klass.organized.flat_map { |inner| flatten_chain(inner) }
    end

    def status_code(error)
      symbol = Errors::HTTPStatusForKind.call(error.kind)
      Rack::Utils.status_code(symbol) if symbol
    end
  end
end

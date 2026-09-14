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

    def mark_guarded(validator_class)
      declarations[validator_class] ||= []
    end

    def guarded?(validator_class)
      declarations.key?(validator_class) || declarations_for(validator_class).any?
    end

    def declarations_for(validator_class)
      validator_class.ancestors.flat_map { |klass| declarations.fetch(klass, []) }.uniq
    end

    def direct_declarations_for(validator_class)
      declarations.fetch(validator_class, [])
    end

    def declarations_for_organizer(organizer_class)
      flatten_chain(organizer_class).flat_map { |klass| declarations_for(klass) }.uniq
    end

    def reset!
      @declarations = {}
    end

    private

    def declarations
      @declarations ||= {}
    end

    def flatten_chain(klass)
      return [klass] unless klass.respond_to?(:organized) && klass.organized.any?

      klass.organized.flat_map { |inner| flatten_chain(inner) }
    end
  end
end

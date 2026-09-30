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

    def register_delegation(interactor_class, target_class)
      bucket = delegations[interactor_class] ||= []
      bucket << target_class unless bucket.include?(target_class)
    end

    def delegations_for(klass)
      delegations.fetch(klass, [])
    end

    def register_absorption(interactor_class, target_class)
      bucket = absorptions[interactor_class] ||= []
      bucket << target_class unless bucket.include?(target_class)
    end

    def absorptions_for(klass)
      absorptions.fetch(klass, [])
    end

    def delegated_retrievers_for(organizer_class)
      flatten_chain(organizer_class).flat_map { |klass| retrievers_behind(klass) }.uniq
    end

    def chain_of(organizer_class)
      flatten_chain(organizer_class)
    end

    def mark_guarded(validator_class)
      declarations[validator_class] ||= []
    end

    def guarded?(validator_class)
      declarations.key?(validator_class) || declarations_for(validator_class).any?
    end

    def declarations_for(validator_class)
      inherited = validator_class.ancestors.flat_map { |klass| declarations.fetch(klass, []) }

      (inherited + relayed_declarations_for(validator_class)).uniq
    end

    def direct_declarations_for(validator_class)
      declarations.fetch(validator_class, [])
    end

    def declarations_for_organizer(organizer_class)
      flatten_chain(organizer_class).flat_map { |klass| declarations_for(klass) }.uniq
    end

    def reset!
      @declarations = {}
      @delegations = {}
      @absorptions = {}
    end

    private

    def declarations
      @declarations ||= {}
    end

    def delegations
      @delegations ||= {}
    end

    def absorptions
      @absorptions ||= {}
    end

    def relayed_declarations_for(klass)
      delegations_for(klass).reject { |target| target < RetrieverOrganizer }.flat_map { |target| declarations_for_organizer(target) }
    end

    def retrievers_behind(klass)
      delegations_for(klass).flat_map do |target|
        (target < RetrieverOrganizer ? [target] : []) + delegated_retrievers_for(target)
      end
    end

    def flatten_chain(klass)
      return [klass] unless klass.respond_to?(:organized) && klass.organized.any?

      klass.organized.flat_map { |inner| flatten_chain(inner) }
    end
  end
end

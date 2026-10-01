require 'rails_helper'

RSpec.describe ErrorRegistry do
  around do |example|
    Rails.application.eager_load!
    snapshot = described_class.instance_variables.index_with { |name| described_class.instance_variable_get(name).deep_dup }
    described_class.reset!
    example.run
  ensure
    snapshot.each { |name, value| described_class.instance_variable_set(name, value) }
  end

  let(:validator_class) do
    Class.new do
      def self.name
        'AnonymousValidator'
      end
    end
  end

  describe '.register' do
    it 'stores a declaration for a validator class' do
      decl = described_class.register(validator_class, NotFoundError)

      expect(decl.error_class).to eq(NotFoundError)
      expect(decl.options).to eq({})
      expect(described_class.declarations_for(validator_class)).to include(decl)
    end

    it 'is idempotent' do
      described_class.register(validator_class, NotFoundError)
      described_class.register(validator_class, NotFoundError)

      expect(described_class.declarations_for(validator_class).size).to eq(1)
    end

    it 'distinguishes declarations by options' do
      described_class.register(validator_class, ACOSSError, kind: :manual_verification_asked)
      described_class.register(validator_class, ACOSSError, kind: :ongoing_manual_verification)

      expect(described_class.declarations_for(validator_class).size).to eq(2)
    end
  end

  describe '.declarations_for' do
    it 'walks ancestors' do
      parent = Class.new do
        def self.name
          'ParentValidator'
        end
      end
      child = Class.new(parent) do
        def self.name
          'ChildValidator'
        end
      end

      described_class.register(parent, ProviderUnknownError)
      described_class.register(child, NotFoundError)

      classes = described_class.declarations_for(child).map(&:error_class)
      expect(classes).to contain_exactly(ProviderUnknownError, NotFoundError)
    end
  end

  describe '.declarations_for_organizer' do
    it 'recursively walks the organize chain' do
      inner_validator = Class.new do
        def self.name
          'InnerValidator'
        end
      end
      sub_organizer = Class.new do
        class << self
          attr_reader :organized
        end
      end
      sub_organizer.instance_variable_set(:@organized, [inner_validator])

      organizer = Class.new do
        class << self
          attr_reader :organized
        end
      end
      organizer.instance_variable_set(:@organized, [sub_organizer])

      described_class.register(inner_validator, NotFoundError)

      classes = described_class.declarations_for_organizer(organizer).map(&:error_class)
      expect(classes).to eq([NotFoundError])
    end
  end

  describe '.declarations_for with delegations' do
    it 'adds the declarations of the interactors a class delegates to, through their organize chain' do
      validator = Class.new
      inner = Class.new do
        class << self
          attr_reader :organized
        end
      end
      inner.instance_variable_set(:@organized, [validator])
      caller = Class.new

      described_class.register(validator, NotFoundError)
      described_class.register_delegation(caller, inner)

      expect(described_class.declarations_for(caller).map(&:error_class)).to eq([NotFoundError])
    end

    it 'keeps the declarations of a delegated retriever out, since they belong to its provider' do
      retriever = Class.new(RetrieverOrganizer)
      caller = Class.new

      described_class.register(retriever, NotFoundError)
      described_class.register_delegation(caller, retriever)

      expect(described_class.declarations_for(caller)).to be_empty
    end
  end

  describe '.delegated_retrievers_for' do
    def organizer_of(*organized)
      organizer = Class.new do
        class << self
          attr_reader :organized
        end
      end
      organizer.instance_variable_set(:@organized, organized)
      organizer
    end

    it 'follows the retrievers an interactor of the chain runs, through the interactors it delegates to' do
      retriever = Class.new(RetrieverOrganizer)
      relay = Class.new
      caller = Class.new

      described_class.register_delegation(caller, relay)
      described_class.register_delegation(relay, retriever)

      expect(described_class.delegated_retrievers_for(organizer_of(caller))).to eq([retriever])
    end

    it 'leaves out the interactors it delegates to, whose errors belong to the caller' do
      validator = Class.new
      caller = Class.new

      described_class.register_delegation(caller, validator)

      expect(described_class.delegated_retrievers_for(organizer_of(caller))).to be_empty
    end

    it 'finds none for a chain that delegates nothing' do
      expect(described_class.delegated_retrievers_for(organizer_of(Class.new))).to be_empty
    end
  end

  describe 'Declaration#build' do
    let(:validator) do
      Class.new do
        def self.name
          'Validator'
        end
      end
    end

    def built_examples(provider_name:)
      described_class.direct_declarations_for(validator).map { |declaration| declaration.build(provider_name:) }
    end

    it 'gives each error the prefix of the organizer provider' do
      described_class.register(validator, ProviderUnknownError)
      described_class.register(validator, ACOSSError, kind: :manual_verification_asked)

      expect(built_examples(provider_name: 'ACOSS').map(&:code)).to contain_exactly('04999', '04501')
    end

    it 'instantiates BadFileFromProviderError with provider and kind' do
      described_class.register(validator, BadFileFromProviderError, kind: :invalid_base64)

      expect(built_examples(provider_name: 'ACOSS').map(&:code)).to eq(['04051'])
    end

    it 'prefers the provider a declaration names over the organizer one' do
      described_class.register(validator, NotFoundError,
        provider: 'CNAF',
        title: 'Dossier allocataire absent CNAF',
        detail: "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.")

      error = built_examples(provider_name: 'Sécurité sociale').first

      expect(error.code).to eq('23003')
      expect(error.title).to eq('Dossier allocataire absent CNAF')
      expect(error.detail).to eq("Le dossier allocataire n'a pas été trouvé auprès de la CNAF.")
    end

    it 'builds the unauthorized and unprocessable errors from their options' do
      described_class.register(validator, InvalidFranceConnectAccessTokenError, type: :not_found_or_expired)
      described_class.register(validator, ProviderUnprocessableEntityError, reason: :unidentified_person)

      expect(built_examples(provider_name: 'CNAV').map(&:code)).to contain_exactly('51502', '37560')
    end
  end
end

require 'rails_helper'

RSpec.describe ErrorRegistry do
  around do |example|
    snapshot = described_class.send(:declarations).deep_dup
    described_class.reset!
    example.run
  ensure
    described_class.instance_variable_set(:@declarations, snapshot)
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

  describe '.examples_for_status' do
    it 'instantiates errors matching the status' do
      validator = Class.new do
        def self.name
          'Validator'
        end
      end
      organizer = Class.new do
        define_singleton_method(:organized) { [validator] }
      end

      described_class.register(validator, NotFoundError)
      described_class.register(validator, ProviderUnknownError)
      described_class.register(validator, ACOSSError, kind: :manual_verification_asked)

      errors_502 = described_class.examples_for_status(organizer, 502, provider_name: 'ACOSS')

      expect(errors_502.map(&:class)).to contain_exactly(ProviderUnknownError, ACOSSError)
      expect(errors_502.find { |e| e.is_a?(ACOSSError) }.code).to eq('04501')

      errors_404 = described_class.examples_for_status(organizer, 404, provider_name: 'ACOSS')
      expect(errors_404.map(&:class)).to eq([NotFoundError])
    end

    it 'instantiates BadFileFromProviderError with provider and kind' do
      validator = Class.new do
        def self.name
          'Validator'
        end
      end
      organizer = Class.new do
        define_singleton_method(:organized) { [validator] }
      end

      described_class.register(validator, BadFileFromProviderError, kind: :invalid_base64)

      errors = described_class.examples_for_status(organizer, 502, provider_name: 'ACOSS')

      expect(errors.size).to eq(1)
      expect(errors.first.code).to eq('04051')
    end
  end
end

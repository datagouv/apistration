require 'rails_helper'

RSpec.describe ValidateResponseEmissionGuard do
  let(:validator_class) { Class.new }

  def emit(error, from: validator_class)
    described_class.record(from, [error])
  end

  describe '.verify!' do
    context 'with two 422 variants of the same error class' do
      before do
        ErrorRegistry.register(validator_class, ProviderUnprocessableEntityError, reason: :unidentified_person)
        ErrorRegistry.register(validator_class, ProviderUnprocessableEntityError, reason: :rejected_civility)
      end

      it 'accepts a spec emitting both reasons' do
        emit(ProviderUnprocessableEntityError.new('CNAV', :unidentified_person))
        emit(ProviderUnprocessableEntityError.new('CNAV', :rejected_civility))

        expect { described_class.verify!(validator_class) }.not_to raise_error
      end

      it 'rejects a spec leaving one reason unemitted' do
        emit(ProviderUnprocessableEntityError.new('CNAV', :unidentified_person))

        expect { described_class.verify!(validator_class) }
          .to raise_error(/never emitted in spec.*rejected_civility/m)
      end
    end

    context 'with two FranceConnect token types' do
      before do
        ErrorRegistry.register(validator_class, InvalidFranceConnectAccessTokenError, type: :malformed_token)
        ErrorRegistry.register(validator_class, InvalidFranceConnectAccessTokenError, type: :not_found_or_expired)
      end

      it 'rejects a spec leaving one type unemitted' do
        emit(InvalidFranceConnectAccessTokenError.new(:malformed_token))

        expect { described_class.verify!(validator_class) }
          .to raise_error(/never emitted in spec.*not_found_or_expired/m)
      end
    end

    context 'with two 404 providers' do
      before do
        ErrorRegistry.register(validator_class, NotFoundError, provider: 'CNAF')
        ErrorRegistry.register(validator_class, NotFoundError, provider: 'MSA')
      end

      it 'rejects a spec leaving one provider unemitted' do
        emit(NotFoundError.new('CNAF'))

        expect { described_class.verify!(validator_class) }
          .to raise_error(/never emitted in spec.*MSA/m)
      end
    end

    context 'with a 404 naming the queried provider itself' do
      it 'accepts it as the generic not found every retriever can return' do
        ErrorRegistry.mark_guarded(validator_class)

        described_class.record(validator_class, [NotFoundError.new('INSEE')], 'INSEE')

        expect { described_class.verify!(validator_class) }.not_to raise_error
      end
    end

    context 'with an error emitted without going through fail_with_error!' do
      it 'rejects an emission no raises declares' do
        ErrorRegistry.mark_guarded(validator_class)

        emit(INSEEError.new(:more_than_one_siege))

        expect { described_class.verify!(validator_class) }
          .to raise_error(/emitted but not declared.*more_than_one_siege/m)
      end
    end

    context 'with an error declared on a parent class' do
      let(:child_class) { Class.new(validator_class) }

      before do
        ErrorRegistry.register(validator_class, INSEEError, kind: :more_than_one_siege)
      end

      it 'accepts the child emitting what its parent declares' do
        emit(INSEEError.new(:more_than_one_siege), from: child_class)

        expect { described_class.verify!(child_class) }.not_to raise_error
      end
    end
  end
end

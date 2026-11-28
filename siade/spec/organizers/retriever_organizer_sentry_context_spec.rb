RSpec.describe RetrieverOrganizer, 'sentry context', type: :organizer do
  subject(:call_organizer) do
    SentryContextDummyOrganizer.call(
      params: identity_params,
      operation_id: 'api_particulier_v3_dummy',
      recipient: '13002526500013',
      provider_name: 'INSEE',
      outcome:
    )
  end

  before(:all) do
    class SentryContextDummyInteractor < ApplicationInteractor
      def call
        context.response = provider_response
        raise NoMethodError, 'undefined method for nil' if context.outcome == :unexpected_exception

        context.errors << provider_error
        context.fail!
      end

      def provider_error
        case context.outcome
        when :error_without_provider
          ProviderConflictError.new(nil)
        when :provider_unknown_error
          ProviderUnknownError.new(context.provider_name, 'whatever')
        end
      end

      def provider_response
        Struct.new(:code, :body).new('501', context.provider_body)
      end
    end

    class SentryContextDummyOrganizer < RetrieverOrganizer
      organize SentryContextDummyInteractor

      before { context.provider_body = '{"erreurs":[{"code":"E1","message":"Aucun dossier pour DUPONT, JEAN, 01011980."}]}' }

      delegate :provider_name, to: :context
    end
  end

  let(:identity_params) do
    {
      nomNaissance: 'DUPONT',
      prenoms: ['JEAN'],
      anneeDateNaissance: 1980,
      moisDateNaissance: 1,
      jourDateNaissance: 1,
      codeCogInseeCommuneNaissance: '75056',
      sexeEtatCivil: 'M'
    }
  end

  let(:sent_contexts) { {} }

  before do
    allow(Sentry).to receive(:set_context) { |title, context| sent_contexts[title] = context }
    allow(Sentry).to receive(:capture_message)
    allow(DataEncryptor).to receive(:new).and_return(instance_double(DataEncryptor, encrypt: 'ENCRYPTED'))
  end

  after { Sentry.get_current_scope.clear }

  context 'when an organizer raises an unexpected error' do
    let(:outcome) { :unexpected_exception }

    it 'sends neither the identity params nor the provider body in clear' do
      expect { call_organizer }.to raise_error(NoMethodError)

      expect(sent_contexts.to_s).not_to include('DUPONT', 'JEAN', '01011980', '75056')
    end

    it 'keeps what helps debugging without being personal' do
      expect { call_organizer }.to raise_error(NoMethodError)

      expect(sent_contexts['Retriever']).to include(
        operation_id: 'api_particulier_v3_dummy',
        provider_name: 'INSEE',
        recipient: '13002526500013',
        http_response_code: '501'
      )
    end

    it 'sends the params and the provider body encrypted' do
      expect { call_organizer }.to raise_error(NoMethodError)

      expect(DataEncryptor).to have_received(:new).with(include('DUPONT', 'Aucun dossier pour DUPONT'))
      expect(sent_contexts['Retriever']).to include(encrypted_details: 'ENCRYPTED')
    end

    context 'when the encryption fails' do
      before do
        allow(DataEncryptor).to receive(:new).and_raise(GPGME::Error::UnusablePublicKey.new(0))
      end

      it 'raises the original error and sends nothing personal in clear' do
        expect { call_organizer }.to raise_error(NoMethodError)

        expect(sent_contexts.to_s).not_to include('DUPONT', 'JEAN', '01011980')
        expect(sent_contexts['Retriever']).to include(encrypted_details: MonitoringService::ENCRYPTION_FAILED_PLACEHOLDER)
      end
    end
  end

  context 'when an error code cannot be computed' do
    let(:outcome) { :error_without_provider }

    it 'still fails the organizer as usual, with the safe keys sent' do
      expect(call_organizer).to be_a_failure

      expect(sent_contexts['Retriever']).to include(operation_id: 'api_particulier_v3_dummy')
    end
  end

  context 'when the provider answers something unknown' do
    let(:outcome) { :provider_unknown_error }

    it 'sends neither the identity params nor the provider body in clear' do
      call_organizer

      expect(sent_contexts.to_s).not_to include('DUPONT', 'JEAN', '01011980', '75056')
    end

    it 'sends the error code of the failure' do
      call_organizer

      expect(sent_contexts['Retriever']).to include(error_codes: [ProviderUnknownError.new('INSEE').code])
    end
  end
end

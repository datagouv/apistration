RSpec.describe FranceTravail::Indemnites::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'France Travail') }

  context 'with a http ok' do
    let(:response) { instance_double(Net::HTTPOK, code: '200', body:) }

    context 'with a valid json' do
      context 'when there is payments' do
        let(:body) { read_payload_file('france_travail/indemnites/valid.json') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'when there is no paiements' do
        context 'when service user is enrolled' do
          let(:body) { read_payload_file('france_travail/indemnites/enrolled_without_payments.json') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
        end

        context 'when service user is not enrolled' do
          let(:body) { read_payload_file('france_travail/indemnites/not_enrolled.json') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
        end
      end
    end

    context 'with an invalid json' do
      let(:body) { 'invalid json' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with an invalid json structure' do
      let(:body) { { what: 'ever' }.to_json }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with a not found response' do
    let(:response) { instance_double(Net::HTTPNotFound, code: '404') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with a no content response' do
    let(:response) { instance_double(Net::HTTPNoContent, code: '204') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(NotFoundError)) }
  end

  context 'with an unknown error' do
    let(:response) { instance_double(Net::HTTPBadRequest, code: '400') }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end
end

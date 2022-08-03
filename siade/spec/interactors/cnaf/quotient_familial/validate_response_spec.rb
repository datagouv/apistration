RSpec.describe CNAF::QuotientFamilial::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'CNAF') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with an invalid code' do
      let(:code) { '500' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with data in payload' do
        let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnaf_quotient_familial_valid_response.mime')) }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'without data in payload' do
        context 'when it is a beneficiary not found' do
          let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnaf_quotient_familial_not_found_response.mime')) }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

          it 'takes libelle retour message' do
            expect(call.errors.first.detail).to eq('Dossier allocataire inexistant. Le document ne peut être édité.')
          end
        end

        context 'when it is a beneficiary disbared' do
          let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnaf_quotient_familial_disbared_beneficiary_response.mime')) }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

          it 'takes libelle retour message' do
            expect(call.errors.first.detail).to eq('Dossier radié. Le document ne peut être édité.')
          end
        end
      end
    end
  end
end

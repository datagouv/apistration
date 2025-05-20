RSpec.describe CNAF::QuotientFamilial::ValidateResponse, type: :validate_response do
  describe '.call' do
    subject(:call) { described_class.call(response:, provider_name: 'CNAF') }

    let(:response) do
      instance_double(Net::HTTPOK, code:, body:)
    end

    context 'with an unknown http code' do
      let(:code) { '511' }
      let(:body) { 'whatever' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end

    context 'when it is an internal error' do
      let(:code) { '500' }
      let(:body) { 'panik Internal Server Error panik everywhere' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }
    end

    context 'with a valid code' do
      let(:code) { '200' }

      context 'with data in payload' do
        let(:body) { read_payload_file('cnaf/quotient_familial_valid_response.mime') }

        it { is_expected.to be_a_success }

        its(:errors) { is_expected.to be_empty }
      end

      context 'without data in payload' do
        context 'when it is a beneficiary not found' do
          let(:body) { read_payload_file('cnaf/quotient_familial_not_found_response.mime') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

          it 'takes libelle retour message' do
            expect(call.errors.first.detail).to eq('Dossier allocataire inexistant. Le document ne peut être édité. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.')
          end
        end

        context 'when it is a beneficiary disbared' do
          let(:body) { read_payload_file('cnaf/quotient_familial_disbared_beneficiary_response.mime') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

          it 'takes libelle retour message' do
            expect(call.errors.first.detail).to eq('Dossier radié. Le document ne peut être édité. Veuillez vérifier que votre recherche est couverte par le périmètre de l\'API.')
          end
        end

        context 'when no QF in response' do
          let(:body) { read_payload_file('cnaf/quotient_familial_no_qf_response.mime') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(CNAFMissingQFError)) }
        end

        context 'when no QF in response and MIME formatting is different' do
          let(:body) { read_payload_file('cnaf/quotient_familial_no_qf_different_mime_format.mime') }

          it { is_expected.to be_a_failure }

          its(:errors) { is_expected.to include(instance_of(CNAFMissingQFError)) }
        end
      end
    end
  end
end

RSpec.describe MockService, type: :service do
  describe '.mock' do
    subject { described_class.new(controller_id, params).mock }

    let(:controller_id) { 'controller_id' }
    let(:params) { { 'param' => 'value' } }

    context 'when there is a mock in backend for this controller and params' do
      let(:mocked_data) do
        {
          status: 200,
          payload: {
            'status' => 'ok'
          }
        }
      end

      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(
          mocked_data
        )
      end

      it { is_expected.to eq(mocked_data) }
    end

    context 'when there is no mock in backend for this controller and params' do
      before do
        allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
      end

      context 'when it is an API entreprise v3 and more' do
        let(:controller_id) { 'api_entreprise_v3_acoss_attestations_sociales' }

        it 'generates an OpenAPI response' do
          expect(subject).to eq({
            status: 200,
            payload: {
              'data' => {
                'document_url' => 'https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-attestation_vigilance_acoss.pdf',
                'expires_in' => 7_889_238
              },
              'links' => {},
              'meta' => {}
            }
          })
        end
      end
    end
  end
end

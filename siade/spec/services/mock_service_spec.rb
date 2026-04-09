RSpec.describe MockService, type: :service do
  describe '.mock' do
    subject { described_class.new(controller_id, params).mock }

    let(:controller_id) { 'controller_id' }
    let(:params) { { 'param' => 'value' } }

    describe 'case insensitivity' do
      let(:params) { { 'param' => 'VaLuE', 'integer' => 1 } }

      it 'downcases all params' do # rubocop:disable RSpec/NoExpectationExample
        allow(MockDataBackend).to receive(:get_response_for).with('controller_id', { 'param' => 'value', 'integer' => 1 }).and_return({})
        subject
      end
    end

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
                'document_url' => 'https://raw.githubusercontent.com/datagouv/apistration/refs/heads/develop/mocks/payloads/api_entreprise_v4_acoss_attestations_sociales/attestation_vigilance_test.pdf',
                'expires_in' => 7_889_238
              },
              'links' => {},
              'meta' => {}
            }
          })
        end
      end

      context 'when it is an API Particulier call' do
        let(:controller_id) { 'api_particulier_whatever' }

        before do
          allow(MockDataBackend).to receive(:get_not_found_response_for).with('api_particulier_whatever').and_return(
            mocked_data
          )
        end

        context 'when there is a not found payload' do
          let(:mocked_data) do
            {
              status: 404,
              payload: {
                'status' => 'not_found'
              }
            }
          end

          it 'generates a 404 response' do
            expect(subject).to eq({
              status: 404,
              payload: {
                'status' => 'not_found'
              }
            })
          end
        end

        context 'when there is no a not found payload' do
          let(:mocked_data) { nil }

          it 'raises error' do
            expect { subject }.to raise_error(MockService::NoNotFoundPayload)
          end
        end
      end
    end
  end
end

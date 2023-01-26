RSpec.describe MockDataBackend, type: :service do
  let(:instance) { described_class.instance }

  def mock_sha_github(sha)
    allow(instance).to receive(:extract_content_from_github).with(sha).and_return(
      Rails.root.join("spec/fixtures/github_mocks/endpoints#{sha}.yaml").read
    )
  end

  before do
    allow(instance).to receive(:fetch_payloads_paths_from_github).and_return(
      [
        {
          sha: '01',
          path: 'payloads/whatever_endpoint1',
          type: 'tree'
        },
        {
          sha: '11',
          path: 'payloads/whatever_endpoint1/1.yaml',
          type: 'blob'
        },
        {
          sha: '12',
          path: 'payloads/whatever_endpoint1/2.yaml',
          type: 'blob'
        },
        {
          sha: '02',
          path: 'payloads/whatever_endpoint2',
          type: 'tree'
        },
        {
          sha: '21',
          path: 'payloads/whatever_endpoint2/1.yaml',
          type: 'blob'
        }
      ]
    )

    %w[11 12 21].each do |sha|
      mock_sha_github(sha)
    end
  end

  describe '.get_response_for' do
    subject { described_class.get_response_for(operation_id, params) }

    context 'when the operation_id does not exist' do
      let(:operation_id) { 'unknown' }
      let(:params) { {} }

      it { is_expected.to be_nil }
    end

    context 'when the operation_id exists' do
      context 'with endpoint1 example' do
        let(:operation_id) { 'whatever_endpoint1' }

        context 'when 3 params match (in whatever order)' do
          let(:params) do
            %w[arg1 arg2 arg3].shuffle.each_with_object({}) do |arg, hash|
              hash[arg] = arg
            end
          end

          it 'returns hash with status and payload' do
            expect(subject).to eq(
              status: 200,
              payload: {
                'status' => 'ok'
              }
            )
          end
        end

        context 'when 2 params match (in whatever order)' do
          let(:params) do
            %w[arg1 arg2].shuffle.each_with_object({}) do |arg, hash|
              hash[arg] = arg
            end
          end

          it 'returns hash with status and payload' do
            expect(subject).to eq(
              status: 404,
              payload: {
                'status' => 'nok'
              }
            )
          end
        end

        context 'without params matching' do
          let(:params) { { 'invalid' => 'invalid' } }

          it { is_expected.to be_nil }
        end

        context 'without params' do
          let(:params) { {} }

          it { is_expected.to be_nil }
        end
      end

      context 'with endpoint2 example' do
        let(:operation_id) { 'whatever_endpoint2' }
        let(:params) { { 'whatever' => 'whatever' } }

        it 'returns hash with status and payload' do
          expect(subject).to eq(
            status: 200,
            payload: {
              'status' => 'ok'
            }
          )
        end
      end
    end
  end

  describe '.reset!' do
    subject { described_class.reset! }

    before do
      described_class.get_response_for('whatever_endpoint2', { 'whatever' => 'whatever' })
    end

    it 'does not raise error' do
      expect { subject }.not_to raise_error
    end
  end
end

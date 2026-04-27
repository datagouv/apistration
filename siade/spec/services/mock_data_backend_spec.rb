RSpec.describe MockDataBackend, type: :service do
  before do
    stub_const('MockDataBackend::PAYLOADS_ROOT', Rails.root.join('spec/fixtures/mock_payloads'))
    described_class.reset!
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
        let(:params) do
          %w[arg1 arg2 arg3].shuffle.to_h do |arg|
            [arg, arg]
          end
        end

        context 'when 3 params match (in whatever order)' do
          it 'returns hash with status and payload' do
            expect(subject).to eq(
              status: 200,
              payload: {
                'status' => 'ok'
              }
            )
          end
        end

        context 'with endpoint example' do
          let(:operation_id) { 'whatever_endpoint' }

          it 'does not collide with another operation id' do
            expect(subject).to eq(
              status: 404,
              payload: {
                'status' => 'nok'
              }
            )
          end
        end

        context 'when 2 params match (in whatever order)' do
          let(:params) do
            %w[arg1 arg2].shuffle.to_h do |arg|
              [arg, arg]
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

        it 'returns hash with status and payload, case insensitive' do
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

  describe '.get_not_found_response_for' do
    subject { described_class.get_not_found_response_for(operation_id) }

    context 'when the operation_id does not exist' do
      let(:operation_id) { 'unknown' }

      it { is_expected.to be_nil }
    end

    context 'when the operation_id exists' do
      context 'with endpoint1 example' do
        let(:operation_id) { 'whatever_endpoint1' }

        it { is_expected.to be_nil }
      end

      context 'with endpoint2 example' do
        let(:operation_id) { 'whatever_endpoint2' }

        it 'returns hash with status and payload' do
          expect(subject).to eq(
            status: 404,
            payload: {
              'status' => 'nok'
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

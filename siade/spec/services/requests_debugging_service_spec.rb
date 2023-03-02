RSpec.describe RequestsDebuggingService, type: :service do
  describe '#enable?' do
    subject { described_class.new(operation_id, status).enable? }

    let(:date) { Time.zone.today }

    before do
      Timecop.freeze(date)
    end

    after do
      Timecop.return
    end

    context 'when operation_id is not in the list' do
      let(:operation_id) { 'operation_id' }
      let(:status) { 200 }

      it { is_expected.to be_falsey }
    end

    context 'when operation_id is in the list' do
      let(:operation_id) { 'api_teapot' }

      context 'when status is valid' do
        let(:status) { 200 }

        context 'when it is before the enable_until' do
          it { is_expected.to be_truthy }
        end

        context 'when it is after the enable_until' do
          let(:date) { Date.new(2052, 1, 1) }

          it { is_expected.to be_falsey }
        end
      end

      context 'when status is not valid' do
        let(:status) { 409 }

        it { is_expected.to be_falsey }
      end
    end
  end
end

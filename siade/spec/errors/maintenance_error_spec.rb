RSpec.describe MaintenanceError, type: :error do
  context 'with a provider which has an active entry in MaintenanceService' do
    let(:provider_name) { 'INSEE' }

    before do
      Timecop.freeze(Time.zone.now.beginning_of_day + 3.hours)
    end

    after do
      Timecop.return
    end

    it_behaves_like 'a valid error' do
      let(:instance) { described_class.new(provider_name) }
    end

    describe '#detail' do
      subject { described_class.new(provider_name).detail }

      it 'has start and end time' do
        expect(subject).to match(/03:00.*04:00/)
      end
    end

    describe '#meta' do
      subject { described_class.new(provider_name).meta }

      it 'has a retry_in key, which specifies in seconds when maintenance is off' do
        expect(subject[:retry_in]).to eq(1.hour.to_i)
      end
    end
  end

  context 'with a provider which has no active entry in MaintenanceService' do
    let(:provider_name) { 'Qualibat' }

    it_behaves_like 'a valid error' do
      let(:instance) { described_class.new(provider_name) }
    end

    describe '#detail' do
      subject { described_class.new(provider_name).detail }

      it 'has no details about hours' do
        expect(subject).not_to match(/\d{2}/)
      end
    end

    describe '#meta' do
      subject { described_class.new(provider_name).meta }

      it 'has no retry_in key' do
        expect(subject).not_to have_key(:retry_in)
      end
    end
  end
end

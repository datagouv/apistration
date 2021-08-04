RSpec.describe MaintenanceError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('INSEE') }
  end

  describe '#detail' do
    subject { described_class.new('INSEE').detail }

    it 'has start and end time' do
      expect(subject).to match(/02:00.*05:00/)
    end
  end

  describe '#meta' do
    subject { described_class.new('INSEE').meta }

    let(:time) { Time.zone.now.beginning_of_day + 3.hours }

    before do
      Timecop.freeze(time)
    end

    after do
      Timecop.return
    end

    it 'has a retry_in key, which specifies in seconds when maintenance is off' do
      expect(subject[:retry_in]).to eq(2.hours.to_i)
    end
  end
end

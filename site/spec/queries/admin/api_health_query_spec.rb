RSpec.describe Admin::APIHealthQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }

  describe '#instant_status' do
    before do
      create(:access_log, controller: controller_name, status: '200', duration: '500', timestamp: 2.minutes.ago)
      create(:access_log, controller: controller_name, status: '404', duration: '300', timestamp: 3.minutes.ago)
      create(:access_log, controller: controller_name, status: '502', duration: '700', timestamp: 5.minutes.ago)
    end

    it 'aggregates status counts for the last 10 minutes' do
      result = query.instant_status

      expect(result.size).to eq(1)
      row = result.first
      expect(row[:controller]).to eq(controller_name)
      expect(row[:total]).to eq(3)
      expect(row[:success]).to eq(1)
      expect(row[:not_found]).to eq(1)
      expect(row[:errors]).to eq(1)
    end

    it 'computes average duration for 200/404 only' do
      row = query.instant_status.first

      expect(row[:avg_duration]).to be_within(0.01).of(400.0)
    end

    it 'excludes calls older than 10 minutes' do
      create(:access_log, controller: controller_name, status: '200', duration: '100', timestamp: 15.minutes.ago)

      expect(query.instant_status.first[:total]).to eq(3)
    end

    it 'excludes ping/uptime controllers' do
      create(:access_log, controller: 'ping', status: '200', duration: '10', timestamp: 1.minute.ago)

      controllers = query.instant_status.map { |r| r[:controller] }
      expect(controllers).not_to include('ping')
    end
  end
end

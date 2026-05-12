RSpec.describe Admin::APIStatusQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }

  before do
    create(:access_log, controller: controller_name, status: '200', cached: false, duration: '500')
    create(:access_log, controller: controller_name, status: '404', cached: true, duration: '300')
    create(:access_log, controller: controller_name, status: '502', cached: false, duration: '700')
  end

  describe '#total_calls' do
    it 'counts all non-401/403 calls' do
      expect(query.total_calls).to eq(3)
    end

    it 'excludes 401 and 403 calls' do
      create(:access_log, controller: controller_name, status: '401')
      create(:access_log, controller: controller_name, status: '403')

      expect(query.total_calls).to eq(3)
    end
  end

  describe '#unique_calls' do
    it 'counts distinct paths' do
      expect(query.unique_calls).to eq(3)
    end
  end

  describe '#cached_calls' do
    it 'counts cached calls only' do
      expect(query.cached_calls).to eq(1)
    end
  end

  describe '#calls_vs_unique_evolution' do
    it 'returns buckets with total and unique counts' do
      result = query.calls_vs_unique_evolution

      expect(result).to be_an(Array)
      expect(result.first).to include(:bucket, :total, :unique)
      expect(result.sum { |r| r[:total] }).to eq(3)
    end
  end

  describe '#cached_evolution' do
    it 'returns buckets with cached totals' do
      result = query.cached_evolution

      expect(result).to be_an(Array)
      expect(result.sum { |r| r[:total] }).to eq(1)
    end
  end

  describe '#duration_evolution' do
    it 'returns average duration for 200/404 statuses only' do
      result = query.duration_evolution

      expect(result).to be_an(Array)
      expect(result.first[:value]).to be_within(0.01).of(400.0)
    end
  end

  describe '#http_code_breakdown' do
    it 'groups by HTTP status code' do
      result = query.http_code_breakdown

      expect(result.map { |r| r[:label] }).to contain_exactly('200', '404', '502')
    end
  end

  describe 'api filter' do
    let(:other_controller) { 'api_entreprise/v3_and_more/dgfip/chiffres_affaires' }

    before do
      create(:access_log, controller: other_controller, status: '200')
    end

    it 'narrows to a specific API when filter.api is set' do
      filtered = Admin::StatisticsFilter.new(api: controller_name)

      expect(described_class.new(filtered).total_calls).to eq(3)
    end
  end

  describe 'excluded controllers' do
    it 'ignores ping/uptime traffic' do
      create(:access_log, controller: 'ping', status: '200')

      expect(query.total_calls).to eq(3)
    end
  end
end

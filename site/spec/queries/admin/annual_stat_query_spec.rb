RSpec.describe Admin::AnnualStatQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new(date_from: 6.months.ago.to_date, date_to: Date.current) }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:token) { create(:token) }

  before do
    Timecop.freeze(2.months.ago.beginning_of_month + 1.day) do
      create(:access_log, controller: controller_name, status: '200', cached: false, duration: '500', token: token,
        params: { 'siret' => '12345678901234' })
      create(:access_log, controller: controller_name, status: '404', cached: true, duration: '300', token: token,
        params: { 'siret' => '12345678901234' })
      create(:access_log, controller: controller_name, status: '502', cached: false, duration: '700', token: token)
    end
  end

  describe '#total_calls' do
    it 'counts all non-401/403 calls' do
      expect(query.total_calls).to eq(3)
    end
  end

  describe '#cached_calls' do
    it 'counts cached calls' do
      expect(query.cached_calls).to eq(1)
    end
  end

  describe '#total_users' do
    it 'counts distinct authorization request external_ids' do
      expect(query.total_users).to eq(1)
    end
  end

  describe '#success_rate_breakdown' do
    it 'splits by 200/404/other' do
      result = query.success_rate_breakdown

      expect(result).to contain_exactly(
        { label: 'Succès (200)', value: 1 },
        { label: 'Non trouvé (404)', value: 1 },
        { label: 'Autre', value: 1 }
      )
    end
  end

  describe '#unique_sirets' do
    it 'counts distinct sirets from params' do
      expect(query.unique_sirets).to eq(1)
    end
  end

  describe '#calls_by_month' do
    it 'returns monthly buckets' do
      result = query.calls_by_month

      expect(result).to be_an(Array)
      expect(result.first).to include(:bucket, :value)
      expect(result.sum { |r| r[:value] }).to eq(3)
    end
  end

  describe '#cumulative_calls_by_month' do
    it 'returns cumulative totals' do
      result = query.cumulative_calls_by_month

      expect(result.last[:value]).to eq(3)
    end
  end

  describe '#users_by_month' do
    it 'returns monthly distinct user counts' do
      result = query.users_by_month

      expect(result).to be_an(Array)
      expect(result.first[:value]).to eq(1)
    end
  end

  describe 'excluded controllers' do
    it 'ignores ping traffic' do
      Timecop.freeze(2.months.ago.beginning_of_month + 1.day) do
        create(:access_log, controller: 'ping', status: '200')
      end

      expect(query.total_calls).to eq(3)
    end
  end
end

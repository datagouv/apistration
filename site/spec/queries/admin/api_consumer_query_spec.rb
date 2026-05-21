RSpec.describe Admin::APIConsumerQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new }
  let(:controller_name) { 'api_entreprise/v3_and_more/insee/etablissements' }

  let(:user) { create(:user, email: 'demandeur@example.com') }
  let(:authorization_request) do
    create(:authorization_request, :with_organization,
      intitule: 'Mairie de X',
      external_id: 'AR-1',
      api: 'entreprise',
      siret: '13002526500013',
      status: :validated)
  end
  let(:token) do
    create(:token, authorization_request: authorization_request, intitule: 'Mairie de X')
  end

  before do
    create(:user_authorization_request_role, user: user, authorization_request: authorization_request, role: 'demandeur')
    create(:access_log, controller: controller_name, status: '200', token: token)
    create(:access_log, controller: controller_name, status: '404', token: token)
    create(:access_log, controller: controller_name, status: '502', token: token)
  end

  describe '#total_calls' do
    it 'counts all non-401/403 calls' do
      expect(query.total_calls).to eq(3)
    end
  end

  describe '#success_breakdown' do
    it 'splits by success/not_found/other' do
      result = query.success_breakdown

      expect(result).to contain_exactly(
        { label: 'Succès', value: 1 },
        { label: 'Non trouvé', value: 1 },
        { label: 'Autre', value: 1 }
      )
    end
  end

  describe '#calls_by_period' do
    it 'returns buckets with totals' do
      result = query.calls_by_period

      expect(result).to be_an(Array)
      expect(result.first).to include(:bucket, :value)
      expect(result.sum { |r| r[:value] }).to eq(3)
    end
  end

  describe '#consumer_habilitations' do
    it 'returns consumers with demandeur email and call count' do
      result = query.consumer_habilitations

      consumer = result.find { |r| r[:external_id] == 'AR-1' }
      expect(consumer).to include(
        intitule: 'Mairie de X',
        email: 'demandeur@example.com',
        siret: '13002526500013'
      )
      expect(consumer[:calls]).to eq(3)
    end
  end

  describe 'excluded controllers' do
    it 'ignores ping traffic' do
      create(:access_log, controller: 'ping', status: '200', token: token)

      expect(query.total_calls).to eq(3)
    end
  end
end

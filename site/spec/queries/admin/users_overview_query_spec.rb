RSpec.describe Admin::UsersOverviewQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new }

  describe '#total_users' do
    it 'returns user count' do
      create_list(:user, 2)

      expect(query.total_users).to eq(User.count)
    end
  end

  describe '#total_habilitations' do
    it 'returns authorization request count' do
      create(:token)

      expect(query.total_habilitations).to eq(AuthorizationRequest.count)
    end
  end

  describe '#total_tokens' do
    it 'returns token count' do
      create_list(:token, 3)

      expect(query.total_tokens).to eq(Token.count)
    end
  end

  describe '#habilitations_with_successful_call' do
    it 'counts distinct authorization requests with a 200 access log' do
      token = create(:token)
      create(:access_log, token: token, status: '200', controller: 'api_entreprise/v3_and_more/insee/etablissements')

      other_token = create(:token)
      create(:access_log, token: other_token, status: '404', controller: 'api_entreprise/v3_and_more/insee/etablissements')

      expect(query.habilitations_with_successful_call).to eq(1)
    end

    it 'respects date_from filter' do
      token = create(:token)
      create(:access_log, token: token, status: '200',
        controller: 'api_entreprise/v3_and_more/insee/etablissements',
        timestamp: 6.months.ago)

      recent_filter = Admin::StatisticsFilter.new(date_from: 1.month.ago.to_date)

      expect(described_class.new(recent_filter).habilitations_with_successful_call).to eq(0)
    end
  end
end

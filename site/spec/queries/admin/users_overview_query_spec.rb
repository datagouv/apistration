RSpec.describe Admin::UsersOverviewQuery do
  subject(:query) { described_class.new(filter) }

  let(:filter) { Admin::StatisticsFilter.new(domaine: 'particulier', status: 'validated') }
  let!(:validated_particulier) { create(:authorization_request, :with_demandeur, api: 'particulier', status: 'validated') }
  let!(:token) { create(:token, authorization_request: validated_particulier) }

  before do
    create(:authorization_request, :with_demandeur, api: 'particulier', status: 'draft')
    create(:token, authorization_request: create(:authorization_request, :with_demandeur, api: 'entreprise', status: 'validated'))
  end

  it 'counts users, habilitations and tokens of the chosen status and domain' do
    expect([query.total_users, query.total_habilitations, query.total_tokens]).to eq([1, 1, 1])
  end

  it 'counts habilitations with a successful call over the 18 months kept by consumption_summary' do
    create(:access_log, controller: 'api_particulier/v3_and_more/cnav/quotient_familial', status: '200', token:, timestamp: 17.months.ago)
    create(:access_log, controller: 'api_particulier/v3_and_more/cnav/quotient_familial', status: '200', token: create(:token), timestamp: 19.months.ago)
    create(:access_log, controller: 'api_particulier/introspect', status: '200', token: create(:token))
    create(:access_log, controller: 'api_particulier/v2/introspect', status: '200', token: create(:token))

    expect(query.habilitations_with_successful_call).to eq(1)
  end
end

RSpec.describe Admin::TokenConsumptionQuery do
  subject(:query) { described_class.new(filter) }

  let(:insee) { 'api_entreprise/v3_and_more/insee/etablissements' }
  let(:demandeur) { create(:user, email: 'demandeur@mairie.fr') }
  let(:authorization_request) { create(:authorization_request, :with_demandeur, demandeur:, demarche: 'editeur-x', external_id: 'DP-1') }
  let(:token) { create(:token, authorization_request:) }
  let(:other_token) { create(:token) }

  before do
    create(:access_log, controller: insee, status: '200', token:, path: '/a', timestamp: 2.days.ago)
    create(:access_log, controller: insee, status: '200', token:, path: '/a', timestamp: 2.days.ago)
    create(:access_log, controller: insee, status: '401', token:, path: '/b', timestamp: 2.days.ago)
    create(:access_log, controller: insee, status: '200', token: other_token, timestamp: 2.days.ago)
  end

  describe 'searching by the demandeur email' do
    let(:filter) { Admin::StatisticsFilter.new(email: 'demandeur@mairie.fr') }

    it 'only lists the contact searched for' do
      create(:user_authorization_request_role, :contact_technique, authorization_request:, user: create(:user, email: 'technique@mairie.fr'))

      expect(query.habilitations.map(&:email)).to eq(['demandeur@mairie.fr'])
    end

    it 'shows the calls of the tokens of their habilitations only' do
      expect(query.tokens_with_consumption).to eq([[token.id, 3]])
      expect(query.consumption_by_api_and_status).to contain_exactly(
        { controller: insee, status: '200', count: 2 },
        { controller: insee, status: '401', count: 1 }
      )
    end

    it 'splits daily calls into unique and repeated ones, without 401 and 403' do
      expect(query.consumption_by_day.map { |row| row.merge(bucket: row[:bucket].to_date) }).to eq([{ bucket: 2.days.ago.to_date, unique: 1, non_unique: 1 }])
    end
  end

  describe 'searching by editor' do
    let(:filter) { Admin::StatisticsFilter.new(demarche: 'editeur-x') }

    it 'lists every contact of the habilitations with their token' do
      create(:user_authorization_request_role, :contact_technique, authorization_request:, user: create(:user, email: 'technique@mairie.fr'))

      rows = query.habilitations.to_a

      expect(rows.map { |row| [row.email, row.role, row.token_id] }).to contain_exactly(
        ['demandeur@mairie.fr', 'demandeur', token.id],
        ['technique@mairie.fr', 'contact_technique', token.id]
      )
    end
  end

  describe 'latest requests' do
    let(:filter) { Admin::StatisticsFilter.new(token_id: token.id, date_from: 1.day.ago.to_date, date_to: Date.current) }

    it 'covers the last 90 days whatever the chosen period, once per request' do
      create(:access_log, controller: insee, status: '200', token:, timestamp: 60.days.ago)
      create(:access_log, controller: insee, status: '200', token:, timestamp: 91.days.ago)
      logged_twice = create(:access_log, controller: insee, status: '502', token:, timestamp: 1.hour.ago)
      create(:access_log, controller: insee, status: '200', token:, timestamp: 30.minutes.ago, request_id: logged_twice.request_id)

      requests = query.recent_requests.to_a

      expect(requests.size).to eq(5)
      expect(requests.first).to have_attributes(request_id: logged_twice.request_id, status: '200')
      expect(requests.last.timestamp).to be_within(1.minute).of(60.days.ago)
    end
  end

  describe 'searching a FranceConnect client on one domain' do
    let(:filter) { Admin::StatisticsFilter.new(france_connect_client_id: 'fc-1', domaine: 'particulier') }

    it 'ignores the calls of the other domain habilitations' do
      create(:access_log, controller: insee, status: '200', token:, timestamp: 2.days.ago, params: { 'france_connect_client' => { 'id' => 'fc-1' } })

      expect(query.consumption_by_api_and_status).to be_empty
    end
  end

  describe 'an invalid token id' do
    let(:filter) { Admin::StatisticsFilter.new(token_id: 'not-a-uuid') }

    it 'finds nothing' do
      expect(query.tokens_with_consumption).to be_empty
      expect(query.recent_requests).to be_empty
    end
  end
end

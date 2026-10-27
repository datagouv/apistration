RSpec.describe Admin::UserStatusQuery do
  subject(:query) { described_class.new(filter) }

  let(:client) { create(:user, email: 'client@commune.fr', first_name: 'Ana', last_name: 'Martin') }
  let(:editor_request) do
    create(:authorization_request, :with_organization, :with_demandeur, demandeur: client,
      api: 'particulier', demarche: 'editeur-x', external_id: '5693', status: 'validated')
  end
  let!(:editor_token) { create(:token, authorization_request: editor_request) }
  let!(:other_token) do
    create(:token, authorization_request: create(:authorization_request, :with_demandeur, api: 'entreprise', external_id: '42', status: 'draft'))
  end

  describe 'listing the clients of an editor' do
    let(:filter) { Admin::StatisticsFilter.new(demarche: 'editeur-x') }

    it 'lists the users and habilitations of that démarche only' do
      expect(query.user_info).to contain_exactly(
        a_hash_including(email: 'client@commune.fr', roles: 'demandeur', external_id: '5693', api: 'particulier')
      )
      expect(query.habilitations.pluck(:external_id)).to eq(['5693'])
    end
  end

  describe 'searching an API Particulier datapass' do
    let(:filter) { Admin::StatisticsFilter.new(domaine: 'particulier', external_id: '5693') }

    it 'counts it once and lists its tokens' do
      expect(query.habilitations_count).to eq(1)
      expect(query.tokens.map(&:first)).to eq([editor_token.id])
    end

    it 'finds nothing on API Entreprise' do
      filter.domaine = 'entreprise'

      expect(query.habilitations_count).to eq(0)
    end
  end

  describe 'searching a token' do
    let(:filter) { Admin::StatisticsFilter.new(token_id: other_token.id) }

    it 'shows the habilitation holding it' do
      expect(query.habilitations.pluck(:external_id)).to eq(['42'])
    end
  end

  describe 'status breakdowns' do
    let(:filter) { Admin::StatisticsFilter.new }

    before do
      create(:token, authorization_request: editor_request, blacklisted_at: 1.day.ago)
      create(:token, authorization_request: editor_request, blacklisted_at: 1.day.from_now)
      create(:token, authorization_request: editor_request, exp: 1.day.ago.to_i)
    end

    it 'counts habilitations with a token by status' do
      expect(query.habilitation_status_breakdown).to eq('draft' => 1, 'validated' => 1)
    end

    it 'tells blacklisted tokens apart from the ones about to be' do
      expect(query.token_status_breakdown).to eq('Actif' => 2, 'Blacklisté' => 1, 'Bientôt blacklisté' => 1, 'Expiré' => 1)
    end
  end
end

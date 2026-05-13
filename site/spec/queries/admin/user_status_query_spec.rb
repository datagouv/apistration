RSpec.describe Admin::UserStatusQuery do
  subject(:query) { described_class.new(filter) }

  let(:user) { create(:user, email: 'test@example.com') }
  let(:filter) { Admin::StatisticsFilter.new(email: user.email) }

  describe '#user_info' do
    it 'returns user matching email' do
      result = query.user_info

      expect(result.size).to eq(1)
      expect(result.first.email).to eq('test@example.com')
    end

    it 'returns empty when email is blank' do
      blank_filter = Admin::StatisticsFilter.new
      expect(described_class.new(blank_filter).user_info).to eq([])
    end
  end

  describe '#user_habilitations' do
    let(:authorization_request) do
      create(:authorization_request, :with_organization,
        intitule: 'Mairie de X', external_id: 'AR-1', api: 'entreprise',
        siret: '13002526500013', status: :validated)
    end

    before do
      create(:user_authorization_request_role, user: user, authorization_request: authorization_request, role: 'demandeur')
    end

    it 'returns habilitations for the user' do
      result = query.user_habilitations

      expect(result.size).to eq(1)
      expect(result.first.external_id).to eq('AR-1')
    end

    it 'returns empty when email is blank' do
      blank_filter = Admin::StatisticsFilter.new
      expect(described_class.new(blank_filter).user_habilitations).to eq([])
    end
  end

  describe '#user_tokens' do
    before do
      create(:token, authorization_request: create(:authorization_request, :with_demandeur, demandeur: user))
    end

    it 'returns tokens for the user' do
      result = query.user_tokens

      expect(result.size).to eq(1)
      expect(result.first.token_id).to be_present
    end

    it 'returns empty when email is blank' do
      blank_filter = Admin::StatisticsFilter.new
      expect(described_class.new(blank_filter).user_tokens).to eq([])
    end
  end

  describe '#habilitation_status_breakdown' do
    before do
      ar1 = create(:authorization_request, status: :validated)
      ar2 = create(:authorization_request, status: :draft)
      create(:user_authorization_request_role, user: user, authorization_request: ar1, role: 'demandeur')
      create(:user_authorization_request_role, user: user, authorization_request: ar2, role: 'demandeur')
    end

    it 'groups by status' do
      result = query.habilitation_status_breakdown

      expect(result.pluck(:label)).to contain_exactly('validated', 'draft')
    end
  end

  describe '#token_status_breakdown' do
    before do
      ar = create(:authorization_request, :with_demandeur, demandeur: user, status: :validated)
      create(:token, authorization_request: ar, exp: 1.year.from_now.to_i, blacklisted_at: nil)
      create(:token, authorization_request: ar, exp: 1.year.ago.to_i, blacklisted_at: nil)
      create(:token, authorization_request: ar, exp: 1.year.from_now.to_i, blacklisted_at: 1.month.ago)
    end

    it 'splits into active/expired/blacklisted' do
      result = query.token_status_breakdown

      expect(result).to contain_exactly(
        { label: 'Actif', value: 1 },
        { label: 'Expiré', value: 1 },
        { label: 'Bloqué', value: 1 }
      )
    end
  end
end

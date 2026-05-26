require 'rails_helper'

RSpec.describe Editor::API::V1::DelegationSerializer do
  let(:authorization_request) do
    create(:authorization_request, :validated,
      api: 'entreprise',
      external_id: '4242',
      siret: '13002526500013',
      intitule: 'My Délégation',
      scopes: %w[unites_legales_etablissements_insee])
  end

  describe '#as_json' do
    it 'serializes an active delegation with all expected fields' do
      delegation = create(:editor_delegation, authorization_request:,
        created_at: Time.zone.local(2026, 3, 14, 12, 0, 0))

      expect(described_class.new(delegation).as_json).to eq(
        id: delegation.id,
        authorization_request_id: 4242,
        siret: '13002526500013',
        intitule: 'My Délégation',
        scopes: %w[unites_legales_etablissements_insee],
        statut: 'active',
        created_at: '2026-03-14T11:00:00Z'
      )
    end

    it 'marks revoked delegations with statut=revoked' do
      delegation = create(:editor_delegation, authorization_request:, revoked_at: 1.hour.ago)

      expect(described_class.new(delegation).as_json).to include(statut: 'revoked')
    end

    it 'returns an empty array when the AR has no scopes' do
      ar_without_scopes = create(:authorization_request, :validated,
        api: 'entreprise', external_id: '5000', scopes: [])
      delegation = create(:editor_delegation, authorization_request: ar_without_scopes)

      expect(described_class.new(delegation).as_json[:scopes]).to eq([])
    end
  end
end

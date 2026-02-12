require 'rails_helper'

RSpec.describe APIEntreprise::ACOSS::AttestationSocialeSerializer::V4, type: :serializer do
  subject(:serialized_hash) { described_class.new(BundledData.new(data:), current_user).serializable_hash }

  let(:current_user) do
    JwtUser.new(
      uid: SecureRandom.uuid,
      scopes: [],
      jti: SecureRandom.uuid,
      iat: 1.year.ago.to_i,
      exp: 1.year.from_now.to_i
    )
  end

  context 'when resource does not expose URSSAF-specific fields (non-regression test)' do
    let(:data) do
      Resource.new(
        document_url: 'https://example.test/doc.pdf',
        document_url_expires_in: 86_400
      )
    end

    it 'serializes without raising NoMethodError' do
      expect(serialized_hash[:data]).to include(
        document_url: 'https://example.test/doc.pdf',
        document_url_expires_in: 86_400,
        date_debut_validite: nil,
        date_fin_validite: nil,
        code_securite: nil,
        entity_status: {}
      )
    end
  end

  context 'when resource exposes URSSAF-specific fields' do
    let(:data) do
      Resource.new(
        document_url: 'https://example.test/doc.pdf',
        document_url_expires_in: 86_400,
        date_debut_validite: Date.new(2026, 1, 31),
        date_fin_validite: Date.new(2026, 7, 31),
        code_securite: 'ABCD1234',
        entity_status_code: 'ok'
      )
    end

    it 'keeps existing behavior' do
      expect(serialized_hash[:data]).to include(
        date_debut_validite: Date.new(2026, 1, 31),
        date_fin_validite: Date.new(2026, 7, 31),
        code_securite: 'ABCD1234',
        entity_status: include(code: 'ok')
      )
    end
  end
end

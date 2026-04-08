# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::MEN::ScolaritesSerializer::V5, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { MEN::Scolarites::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('men/scolarites/valid_v2_with_bourse.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with men_regime_pensionnat scope' do
    let(:scopes) { %w[men_regime_pensionnat] }

    it 'has only regime_pensionnat key' do
      expect(subject[:data]).to have_key(:regime_pensionnat)
      expect(subject[:data].keys).to eq([:regime_pensionnat])
    end
  end

  context 'without men_regime_pensionnat scope' do
    let(:scopes) { %w[men_statut_scolarite] }

    it 'does not have regime_pensionnat key' do
      expect(subject[:data]).not_to have_key(:regime_pensionnat)
    end
  end
end

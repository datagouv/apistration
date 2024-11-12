# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::RevenuSolidariteActive::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::RevenuSolidariteActive::BuildResource.call(response:).bundled_data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('cnav/revenu_solidarite_active/make_request_valid.json') }
  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial revenu solidarite active scopes' do
    context 'with revenu_solidarite_active scope' do
      let(:scopes) { %w[revenu_solidarite_active] }

      it 'has status, date_debut items' do
        expect(subject[:data]).to have_key(:est_beneficiaire)
        expect(subject[:data]).to have_key(:date_debut_droit)
      end
    end
  end

  context 'with all scopes' do
    let(:scopes) { %w[revenu_solidarite_active revenu_solidarite_active_majoration] }

    it 'has all items' do
      expect(subject[:data]).to have_key(:est_beneficiaire)
      expect(subject[:data]).to have_key(:date_debut_droit)
      expect(subject[:data]).to have_key(:avec_majoration)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::RevenuSolidariteActive::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::RevenuSolidariteActive::BuildResource.call(response: response).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body: body) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('cnav/revenu_solidarite_active/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial cnav_revenu_solidarite_active_majoration scopes' do
    context 'with revenu_solidarite_active scope' do
      let(:scopes) { %w[revenu_solidarite_active] }
      
      it 'has status, dateDebut and dateFin items' do
        expect(subject[:data]).to have_key(:status)
        expect(subject[:data]).to have_key(:dateDebut)
        expect(subject[:data]).to have_key(:dateFin)
      end
    end
  end

  context 'with all scopes' do
    let(:scopes) { %w[revenu_solidarite_active revenu_solidarite_active_majoration] }

    it 'has all items' do
      expect(subject[:data]).to have_key(:status)
      expect(subject[:data]).to have_key(:dateDebut)
      expect(subject[:data]).to have_key(:dateFin)
      expect(subject[:data]).to have_key(:majoration)
    end
  end
end

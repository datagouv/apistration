# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::ComplementaireSanteSolidaire::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::ComplementaireSanteSolidaire::BuildResource.call(response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial revenu solidarite active scopes' do
    context 'with complementaire_sante_solidaire scope' do
      let(:scopes) { %w[complementaire_sante_solidaire] }

      it 'has status, date_debut and date_fin items' do
        expect(subject[:data]).to have_key(:status)
        expect(subject[:data]).to have_key(:date_debut)
        expect(subject[:data]).to have_key(:date_fin)
      end
    end
  end
end

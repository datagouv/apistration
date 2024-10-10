# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::PrimeActivite::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::PrimeActivite::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { read_payload_file('cnav/prime_activite/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial revenu solidarite active scopes' do
    context 'with prime_activite scope' do
      let(:scopes) { %w[prime_activite] }

      it 'has status, date_debut and date_fin items' do
        expect(subject[:data]).to have_key(:status)
        expect(subject[:data]).to have_key(:date_debut)
        expect(subject[:data]).to have_key(:date_fin)
      end
    end
  end

  context 'with all scopes' do
    let(:scopes) { %w[prime_activite prime_activite_majoration] }

    it 'has all items' do
      expect(subject[:data]).to have_key(:status)
      expect(subject[:data]).to have_key(:date_debut)
      expect(subject[:data]).to have_key(:date_fin)
      expect(subject[:data]).to have_key(:majoration)
    end
  end
end

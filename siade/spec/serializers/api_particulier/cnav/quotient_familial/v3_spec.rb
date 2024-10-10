# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::QuotientFamilial::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::QuotientFamilialV2::BuildResource.call(response:, params:).bundled_data }
  let(:params) { { annee:, mois: } }
  let(:annee) { Time.zone.today.year }
  let(:mois) { Time.zone.today.month }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { read_payload_file('cnav/quotient_familial_v2/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  before do
    response['X-APISECU-FD'] = CNAV::QuotientFamilialV2::REGIME_CODE_CNAF
  end

  context 'with partial revenu solidarite active scopes' do
    context 'with quotient_familial scope' do
      let(:scopes) { %w[cnaf_quotient_familial] }

      it 'has status, dateDebut and dateFin items' do
        expect(subject[:data]).to have_key(:quotient_familial)
        expect(subject[:data]).not_to have_key(:allocataires)
        expect(subject[:data]).not_to have_key(:enfants)
        expect(subject[:data]).not_to have_key(:adresse)
      end
    end
  end

  context 'with all scopes' do
    let(:scopes) { %w[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

    it 'has all items' do
      expect(subject[:data]).to have_key(:quotient_familial)
      expect(subject[:data]).to have_key(:allocataires)
      expect(subject[:data]).to have_key(:enfants)
      expect(subject[:data]).to have_key(:adresse)
    end
  end
end

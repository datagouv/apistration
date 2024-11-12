# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::CNAV::AllocationSoutienFamilial::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNAV::AllocationSoutienFamilial::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { read_payload_file('cnav/allocation_soutien_familial/make_request_valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial revenu solidarite active scopes' do
    context 'with allocation_soutien_familial scope' do
      let(:scopes) { %w[allocation_soutien_familial] }

      it 'has status, date_debut items' do
        expect(subject[:data]).to have_key(:est_beneficiaire)
        expect(subject[:data]).to have_key(:date_debut_droit)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::FranceTravail::IndemnitesSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { FranceTravail::Indemnites::BuildResource.call(params: { identifiant: 'test' }, response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('france_travail/indemnites/valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with all france_travails scopes' do
    context 'with pole_emploi_paiements scope' do
      let(:scopes) { %w[pole_emploi_paiements] }

      it 'has all the data' do
        expect(subject[:data]).to have_key(:identifiant)
        # rubocop:disable RSpec/IteratedExpectation
        subject[:data][:paiements].each do |paiement|
          expect(paiement).to have_key(:date_versement)
          expect(paiement).to have_key(:montant_total)
          expect(paiement).to have_key(:montant_allocations)
          expect(paiement).to have_key(:montant_aides)
          expect(paiement).to have_key(:montant_autres)
        end
        # rubocop:enable RSpec/IteratedExpectation
      end
    end

    context 'without pole_emploi_paiements scope' do
      let(:scopes) { %w[] }

      it 'has only identifiant item' do
        expect(subject[:data]).to have_key(:identifiant)
        expect(subject[:data]).not_to have_key(:paiements)
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::MESRI::StatutEtudiantSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { MESRI::StudentStatus::BuildResource.call(response:).bundled_data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse
  let(:body) { read_payload_file('mesri/student_status/with_ine_valid_response.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial mesri scopes' do
    context 'with mesri_identite scope' do
      let(:scopes) { %w[mesri_identite] }

      it 'has nom, prenom and date_naissance items' do
        expect(subject[:data]).to have_key(:nom)
        expect(subject[:data]).to have_key(:prenom)
        expect(subject[:data]).to have_key(:date_naissance)
      end
    end

    context 'with mesri_regime scope' do
      let(:scopes) { %w[mesri_regime] }

      it 'has regime item' do
        subject[:data][:inscriptions].each do |inscription_payload|
          expect(inscription_payload).to have_key(:regime)
          expect(inscription_payload).to have_key(:date_debut_inscription)
          expect(inscription_payload).to have_key(:date_fin_inscription)

          expect(inscription_payload).not_to have_key(:statut)
          expect(inscription_payload).not_to have_key(:etablissement)
          expect(inscription_payload).not_to have_key(:code_commune)
        end
      end
    end

    context 'with mesri_statut scope' do
      let(:scopes) { %w[mesri_statut] }

      it 'has statut item' do
        subject[:data][:inscriptions].each do |inscription_payload|
          expect(inscription_payload).to have_key(:statut)
          expect(inscription_payload).to have_key(:date_debut_inscription)
          expect(inscription_payload).to have_key(:date_fin_inscription)

          expect(inscription_payload).not_to have_key(:regime)
          expect(inscription_payload).not_to have_key(:etablissement)
          expect(inscription_payload).not_to have_key(:code_commune)
        end
      end
    end

    context 'with mesri_etablissements scope' do
      let(:scopes) { %w[mesri_etablissements] }

      it 'has etablissements items' do
        subject[:data][:inscriptions].each do |inscription_payload|
          expect(inscription_payload).to have_key(:etablissement)
          expect(inscription_payload).to have_key(:code_commune)
          expect(inscription_payload).to have_key(:date_debut_inscription)
          expect(inscription_payload).to have_key(:date_fin_inscription)

          expect(inscription_payload).not_to have_key(:statut)
          expect(inscription_payload).not_to have_key(:regime)
        end
      end
    end
  end
end

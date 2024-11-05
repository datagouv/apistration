# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::MESRI::StatutEtudiantSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { MESRI::StudentStatus::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { read_payload_file('mesri/student_status/with_ine_valid_response.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with partial mesri scopes' do
    context 'with mesri_identite scope' do
      let(:scopes) { %w[mesri_identite] }

      it 'has nom, prenom and date_naissance items' do
        expect(subject[:data]).to have_key(:identite)
        expect(subject[:data]).not_to have_key(:admissions)
      end
    end

    context 'with mesri_inscription scope' do
      let(:scopes) { %w[mesri_inscription] }

      it 'has statut item' do
        subject[:data][:admissions].each do |admission_payload|
          expect(admission_payload).to have_key(:date_debut)
          expect(admission_payload).to have_key(:date_fin)
          expect(admission_payload).to have_key(:est_inscrit)
          expect(admission_payload).to have_key(:code_cog_insee_commune)
          expect(admission_payload).not_to have_key(:regime_formation)
          expect(admission_payload).not_to have_key(:etablissement_etudes)
        end
      end
    end

    context 'with mesri_regime scope' do
      let(:scopes) { %w[mesri_inscription mesri_regime] }

      it 'has regime item' do
        subject[:data][:admissions].each do |admission_payload|
          expect(admission_payload).to have_key(:date_debut)
          expect(admission_payload).to have_key(:date_fin)
          expect(admission_payload).to have_key(:est_inscrit)
          expect(admission_payload).to have_key(:code_cog_insee_commune)
          expect(admission_payload).to have_key(:regime_formation)
          expect(admission_payload).not_to have_key(:etablissement_etudes)
        end
      end
    end

    context 'with mesri_etablissements scope' do
      let(:scopes) { %w[mesri_inscription mesri_etablissements] }

      it 'has etablissements items' do
        subject[:data][:admissions].each do |admission_payload|
          expect(admission_payload).to have_key(:date_debut)
          expect(admission_payload).to have_key(:date_fin)
          expect(admission_payload).to have_key(:est_inscrit)
          expect(admission_payload).to have_key(:code_cog_insee_commune)
          expect(admission_payload).to have_key(:etablissement_etudes)
          expect(admission_payload).not_to have_key(:regime_formation)
          expect(admission_payload).not_to have_key(:code_formation)
        end
      end
    end
  end
end

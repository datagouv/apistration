# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::FranceTravail::StatutSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { FranceTravail::Statut::BuildResource.call(params: { identifiant: 'test' }, response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('france_travail/statut/valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  context 'with all france_travail scopes' do
    context 'with pole_emploi_paiements scope' do
      let(:scopes) { %w[pole_emploi_identifiant pole_emploi_identite pole_emploi_adresse pole_emploi_contact pole_emploi_inscription] }

      it 'has all the data' do
        expect(subject[:data]).to have_key(:identifiant)
        expect(subject[:data]).to have_key(:identite)
        expect(subject[:data]).to have_key(:contact)
        expect(subject[:data]).to have_key(:inscription)
        expect(subject[:data]).to have_key(:adresse)
      end
    end
  end

  context 'with partial france_travail scopes' do
    context 'with pole_emploi_identifiant scope' do
      let(:scopes) { %w[pole_emploi_identifiant] }

      it 'has only the identifiant' do
        expect(subject[:data]).to have_key(:identifiant)
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:contact)
        expect(subject[:data]).not_to have_key(:inscription)
        expect(subject[:data]).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_identite scope' do
      let(:scopes) { %w[pole_emploi_identite] }

      it 'has only the identite' do
        expect(subject[:data]).not_to have_key(:identifiant)
        expect(subject[:data]).to have_key(:identite)
        expect(subject[:data]).not_to have_key(:contact)
        expect(subject[:data]).not_to have_key(:inscription)
        expect(subject[:data]).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_contact scope' do
      let(:scopes) { %w[pole_emploi_contact] }

      it 'has only the contact' do
        expect(subject[:data]).not_to have_key(:identifiant)
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).to have_key(:contact)
        expect(subject[:data]).not_to have_key(:inscription)
        expect(subject[:data]).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_inscription scope' do
      let(:scopes) { %w[pole_emploi_inscription] }

      it 'has only the inscription' do
        expect(subject[:data]).not_to have_key(:identifiant)
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:contact)
        expect(subject[:data]).to have_key(:inscription)
        expect(subject[:data]).not_to have_key(:adresse)
      end
    end

    context 'with pole_emploi_adresse scope' do
      let(:scopes) { %w[pole_emploi_adresse] }

      it 'has only the adresse' do
        expect(subject[:data]).not_to have_key(:identifiant)
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:contact)
        expect(subject[:data]).not_to have_key(:inscription)
        expect(subject[:data]).to have_key(:adresse)
      end
    end
  end
end

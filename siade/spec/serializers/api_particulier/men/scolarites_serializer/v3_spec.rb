# frozen_string_literal: true

require 'rails_helper'

RSpec.describe APIParticulier::MEN::ScolaritesSerializer::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { MEN::Scolarites::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }
  let(:body) { read_payload_file('men/scolarites/valid.json') }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:all_men_scopes) { %w[men_statut_identite men_statut_scolarite men_statut_etablissement men_statut_module_elementaire_formation men_statut_boursier men_echelon_bourse] }

  context 'with all men scopes' do
    let(:scopes) { all_men_scopes }

    it 'has all keys' do
      expect(subject[:data]).to have_key(:identite)
      expect(subject[:data]).to have_key(:est_scolarise)
      expect(subject[:data]).to have_key(:etablissement)
      expect(subject[:data]).to have_key(:module_elementaire_formation)
      expect(subject[:data]).to have_key(:est_boursier)
      expect(subject[:data]).to have_key(:echelon_bourse)
    end
  end

  context 'with partial men scopes' do
    context 'with men_statut_identite scope' do
      let(:scopes) { %w[men_statut_identite] }

      it 'has key identite' do
        expect(subject[:data]).to have_key(:identite)
        expect(subject[:data]).not_to have_key(:est_scolarise)
        expect(subject[:data]).not_to have_key(:etablissement)
        expect(subject[:data]).not_to have_key(:module_elementaire_formation)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
      end
    end

    context 'with men_statut_scolarite scope' do
      let(:scopes) { %w[men_statut_scolarite] }

      it 'has keys est_scolarise' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).to have_key(:est_scolarise)
        expect(subject[:data]).not_to have_key(:etablissement)
        expect(subject[:data]).not_to have_key(:module_elementaire_formation)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
      end
    end

    context 'with men_statut_etablissement scope' do
      let(:scopes) { %w[men_statut_etablissement] }

      it 'has keys est_scolarise' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:est_scolarise)
        expect(subject[:data]).to have_key(:etablissement)
        expect(subject[:data]).not_to have_key(:module_elementaire_formation)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
      end
    end

    context 'with men_statut_module_elementaire_formation scope' do
      let(:scopes) { %w[men_statut_module_elementaire_formation] }

      it 'has keys est_scolarise' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:est_scolarise)
        expect(subject[:data]).not_to have_key(:etablissement)
        expect(subject[:data]).to have_key(:module_elementaire_formation)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
      end
    end

    context 'with men_statut_boursier scope' do
      let(:scopes) { %w[men_statut_boursier] }

      it 'has keys est_bouriser' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:est_scolarise)
        expect(subject[:data]).not_to have_key(:etablissement)
        expect(subject[:data]).not_to have_key(:module_elementaire_formation)
        expect(subject[:data]).to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
      end
    end

    context 'with men_echelon_bourse scope' do
      let(:scopes) { %w[men_echelon_bourse] }

      it 'has keys est_boursier' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:est_scolarise)
        expect(subject[:data]).not_to have_key(:etablissement)
        expect(subject[:data]).not_to have_key(:module_elementaire_formation)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).to have_key(:echelon_bourse)
      end
    end
  end
end

RSpec.describe APIParticulier::CNOUS::EtudiantBoursier::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNOUS::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { cnous_valid_payload('ine').to_json }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with all cnous scopes' do
    let(:scopes) { all_cnous_scopes }

    it 'has all keys' do
      expect(subject[:data]).to have_key(:identite)
      expect(subject[:data]).to have_key(:email)
      expect(subject[:data]).to have_key(:est_boursier)
      expect(subject[:data]).to have_key(:echelon_bourse)
      expect(subject[:data]).to have_key(:periode_versement_bourse)
      expect(subject[:data]).to have_key(:etablissement_etudes)
    end
  end

  context 'with partial cnous scopes' do
    context 'with cnous_identite scope' do
      let(:scopes) { %w[cnous_identite] }

      it 'has the cnous_identite keys' do
        expect(subject[:data]).to have_key(:identite)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:periode_versement_bourse)
        expect(subject[:data]).not_to have_key(:etablissement_etudes)
      end
    end

    context 'with cnous_email scope' do
      let(:scopes) { %w[cnous_email] }

      it 'has the cnous_email keys' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).to have_key(:email)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:periode_versement_bourse)
        expect(subject[:data]).not_to have_key(:etablissement_etudes)
      end
    end

    context 'with cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_statut_boursier] }

      it 'has the cnous_statut_boursier keys' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:periode_versement_bourse)
        expect(subject[:data]).not_to have_key(:etablissement_etudes)
      end
    end

    context 'with cnous_echelon_bourse scope' do
      let(:scopes) { %w[cnous_echelon_bourse] }

      it 'has the cnous_echelon_bourse keys' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:periode_versement_bourse)
        expect(subject[:data]).not_to have_key(:etablissement_etudes)
      end
    end

    context 'with cnous_periode_versement scope' do
      let(:scopes) { %w[cnous_periode_versement] }

      it 'has the cnous_periode_versement keys' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).to have_key(:periode_versement_bourse)
        expect(subject[:data]).not_to have_key(:etablissement_etudes)
      end
    end

    context 'with cnous_ville_etudes scope' do
      let(:scopes) { %w[cnous_ville_etudes] }

      it 'has the cnous_ville_etudes keys' do
        expect(subject[:data]).not_to have_key(:identite)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:est_boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:periode_versement_bourse)
        expect(subject[:data]).to have_key(:etablissement_etudes)
      end
    end
  end
end

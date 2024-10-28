RSpec.describe APIParticulier::CNOUS::EtudiantBoursier::V3, type: :serializer do
  subject { described_class.new(bundled_data, current_user).serializable_hash }

  let(:bundled_data) { CNOUS::BuildResource.call(response:).bundled_data }

  let(:response) { OpenStruct.new(body:) }

  let(:body) { cnous_valid_payload('ine').to_json }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with all cnous scopes' do
    let(:scopes) { all_cnous_scopes }

    it 'has all keys' do
      expect(subject[:data]).to have_key(:nom)
      expect(subject[:data]).to have_key(:prenom)
      expect(subject[:data]).to have_key(:prenom2)
      expect(subject[:data]).to have_key(:date_naissance)
      expect(subject[:data]).to have_key(:lieu_naissance)
      expect(subject[:data]).to have_key(:sexe)
      expect(subject[:data]).to have_key(:email)
      expect(subject[:data]).to have_key(:boursier)
      expect(subject[:data]).to have_key(:echelon_bourse)
      expect(subject[:data]).to have_key(:statut)
      expect(subject[:data]).to have_key(:statut_libelle)
      expect(subject[:data]).to have_key(:date_de_rentree)
      expect(subject[:data]).to have_key(:duree_versement)
      expect(subject[:data]).to have_key(:ville_etudes)
      expect(subject[:data]).to have_key(:etablissement)
    end
  end

  context 'with partial cnous scopes' do
    context 'with cnous_identite scope' do
      let(:scopes) { %w[cnous_identite] }

      it 'has the cnous_identite keys' do
        expect(subject[:data]).to have_key(:nom)
        expect(subject[:data]).to have_key(:prenom)
        expect(subject[:data]).to have_key(:prenom2)
        expect(subject[:data]).to have_key(:date_naissance)
        expect(subject[:data]).to have_key(:lieu_naissance)
        expect(subject[:data]).to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_email scope' do
      let(:scopes) { %w[cnous_email] }

      it 'has the cnous_email keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_statut_boursier] }

      it 'has the cnous_statut_boursier keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_echelon_bourse scope' do
      let(:scopes) { %w[cnous_echelon_bourse] }

      it 'has the cnous_echelon_bourse keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_statut_bourse scope' do
      let(:scopes) { %w[cnous_statut_bourse] }

      it 'has the cnous_statut_bourse keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).to have_key(:statut)
        expect(subject[:data]).to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_periode_versement scope' do
      let(:scopes) { %w[cnous_periode_versement] }

      it 'has the cnous_periode_versement keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).to have_key(:date_de_rentree)
        expect(subject[:data]).to have_key(:duree_versement)
        expect(subject[:data]).not_to have_key(:ville_etudes)
        expect(subject[:data]).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_ville_etudes scope' do
      let(:scopes) { %w[cnous_ville_etudes] }

      it 'has the cnous_ville_etudes keys' do
        expect(subject[:data]).not_to have_key(:nom)
        expect(subject[:data]).not_to have_key(:prenom)
        expect(subject[:data]).not_to have_key(:prenom2)
        expect(subject[:data]).not_to have_key(:date_naissance)
        expect(subject[:data]).not_to have_key(:lieu_naissance)
        expect(subject[:data]).not_to have_key(:sexe)
        expect(subject[:data]).not_to have_key(:email)
        expect(subject[:data]).not_to have_key(:boursier)
        expect(subject[:data]).not_to have_key(:echelon_bourse)
        expect(subject[:data]).not_to have_key(:statut)
        expect(subject[:data]).not_to have_key(:statut_libelle)
        expect(subject[:data]).not_to have_key(:date_de_rentree)
        expect(subject[:data]).not_to have_key(:duree_versement)
        expect(subject[:data]).to have_key(:ville_etudes)
        expect(subject[:data]).to have_key(:etablissement)
      end
    end
  end
end

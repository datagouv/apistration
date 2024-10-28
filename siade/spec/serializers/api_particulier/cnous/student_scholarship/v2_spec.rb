RSpec.describe APIParticulier::CNOUS::StudentScholarship::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(resource, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:resource) { CNOUS::BuildResource.call(response:).bundled_data.data }
  let(:response) { OpenStruct.new(body:) }
  let(:body) { cnous_valid_payload('ine').to_json }

  let(:all_cnous_scopes) { %w[cnous_identite cnous_email cnous_statut_boursier cnous_echelon_bourse cnous_statut_bourse cnous_periode_versement cnous_ville_etudes] }

  context 'with all cnous scopes' do
    let(:scopes) { all_cnous_scopes }

    it 'has all keys' do
      expect(serialized_resource).to have_key(:nom)
      expect(serialized_resource).to have_key(:prenom)
      expect(serialized_resource).to have_key(:prenom2)
      expect(serialized_resource).to have_key(:dateNaissance)
      expect(serialized_resource).to have_key(:lieuNaissance)
      expect(serialized_resource).to have_key(:sexe)
      expect(serialized_resource).to have_key(:email)
      expect(serialized_resource).to have_key(:boursier)
      expect(serialized_resource).to have_key(:echelonBourse)
      expect(serialized_resource).to have_key(:statut)
      expect(serialized_resource).to have_key(:statutLibelle)
      expect(serialized_resource).to have_key(:dateDeRentree)
      expect(serialized_resource).to have_key(:dureeVersement)
      expect(serialized_resource).to have_key(:villeEtudes)
      expect(serialized_resource).to have_key(:etablissement)
    end
  end

  context 'with partial cnous scopes' do
    context 'with cnous_identite scope' do
      let(:scopes) { %w[cnous_identite] }

      it 'has the cnous_identite keys' do
        expect(serialized_resource).to have_key(:nom)
        expect(serialized_resource).to have_key(:prenom)
        expect(serialized_resource).to have_key(:prenom2)
        expect(serialized_resource).to have_key(:dateNaissance)
        expect(serialized_resource).to have_key(:lieuNaissance)
        expect(serialized_resource).to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_email scope' do
      let(:scopes) { %w[cnous_email] }

      it 'has the cnous_email keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_statut_boursier scope' do
      let(:scopes) { %w[cnous_statut_boursier] }

      it 'has the cnous_statut_boursier keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_echelon_bourse scope' do
      let(:scopes) { %w[cnous_echelon_bourse] }

      it 'has the cnous_echelon_bourse keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_statut_bourse scope' do
      let(:scopes) { %w[cnous_statut_bourse] }

      it 'has the cnous_statut_bourse keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).to have_key(:statut)
        expect(serialized_resource).to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_periode_versement scope' do
      let(:scopes) { %w[cnous_periode_versement] }

      it 'has the cnous_periode_versement keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).to have_key(:dateDeRentree)
        expect(serialized_resource).to have_key(:dureeVersement)
        expect(serialized_resource).not_to have_key(:villeEtudes)
        expect(serialized_resource).not_to have_key(:etablissement)
      end
    end

    context 'with cnous_ville_etudes scope' do
      let(:scopes) { %w[cnous_ville_etudes] }

      it 'has the cnous_ville_etudes keys' do
        expect(serialized_resource).not_to have_key(:nom)
        expect(serialized_resource).not_to have_key(:prenom)
        expect(serialized_resource).not_to have_key(:prenom2)
        expect(serialized_resource).not_to have_key(:dateNaissance)
        expect(serialized_resource).not_to have_key(:lieuNaissance)
        expect(serialized_resource).not_to have_key(:sexe)
        expect(serialized_resource).not_to have_key(:email)
        expect(serialized_resource).not_to have_key(:boursier)
        expect(serialized_resource).not_to have_key(:echelonBourse)
        expect(serialized_resource).not_to have_key(:statut)
        expect(serialized_resource).not_to have_key(:statutLibelle)
        expect(serialized_resource).not_to have_key(:dateDeRentree)
        expect(serialized_resource).not_to have_key(:dureeVersement)
        expect(serialized_resource).to have_key(:villeEtudes)
        expect(serialized_resource).to have_key(:etablissement)
      end
    end
  end
end

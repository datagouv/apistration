RSpec.describe APIParticulier::MESRI::StudentStatus::V2, type: :serializer do
  subject(:serialized_resource) { described_class.new(resource, { scope: current_user, scope_name: :current_user }).serializable_hash }

  let(:current_user) { JwtUser.new(uid: SecureRandom.uuid, scopes:, jti: SecureRandom.uuid, iat: 1.year.ago.to_i, exp: 1.year.from_now.to_i) }

  let(:resource) { MESRI::StudentStatus::BuildResource.call(response:).bundled_data.data }
  # rubocop:disable Style/OpenStructUse
  let(:response) { OpenStruct.new(body:) }
  # rubocop:enable Style/OpenStructUse

  let(:all_scopes) { %w[mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements] }

  context 'with all scopes' do
    let(:scopes) { all_scopes }

    context 'when resource has inscrit status' do
      let(:body) { Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_valid_response.json').read }

      # rubocop:disable RSpec/IteratedExpectation
      it 'has dateDebutInscription and dateFinInscription in inscriptions items' do
        serialized_resource[:inscriptions].each do |inscription_payload|
          expect(inscription_payload).to have_key(:dateDebutInscription)
          expect(inscription_payload).to have_key(:dateFinInscription)
        end
      end
      # rubocop:enable RSpec/IteratedExpectation
    end

    context 'when resource has admis status' do
      let(:body) { Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_valid_response_with_admis_statut.json').read }

      # rubocop:disable RSpec/IteratedExpectation
      it 'has dateDebutAdmission and dateFinAdmission in inscriptions items' do
        serialized_resource[:inscriptions].each do |inscription_payload|
          expect(inscription_payload).to have_key(:dateDebutAdmission)
          expect(inscription_payload).to have_key(:dateFinAdmission)
        end
      end
      # rubocop:enable RSpec/IteratedExpectation
    end
  end
end

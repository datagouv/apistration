RSpec.describe APIParticulier::V2::MESRI::StudentStatusController, type: :controller do
  subject { get :show, params: { ine:, token: } }

  let(:all_scopes) { %w[mesri_identifiant mesri_identite mesri_inscription_etudiant mesri_inscription_autre mesri_admission mesri_etablissements] }
  let(:one_field_of_each_scope) { %w[ine nom inscriptions] }

  describe 'with valid params' do
    let(:token) { TokenFactory.new(scopes).valid }

    let(:ine) { '1234567890G' }

    before do
      stub_request(:get, /#{Siade.credentials[:mesri_student_status_url]}/).to_return(
        status: 200,
        body: File.read(Rails.root.join('spec/fixtures/payloads/mesri_student_status_valid_response.json'))
      )
    end

    context 'when token has full access' do
      let(:scopes) { all_scopes }

      its(:status) { is_expected.to eq(200) }

      it 'returns all fields' do
        json = JSON.parse(subject.body)

        one_field_of_each_scope.each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end
      end
    end

    context 'when mesri_identite is missing' do
      let(:scopes) { all_scopes - %w[mesri_identite] }

      it 'does not return fields associated to this scope' do
        json = JSON.parse(subject.body)

        (one_field_of_each_scope - %w[nom]).each do |key|
          expect(json).to have_key(key), "#{key} is missing"
        end

        expect(json).not_to have_key('nom')
      end
    end
  end
end

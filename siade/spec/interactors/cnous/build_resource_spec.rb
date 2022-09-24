RSpec.describe CNOUS::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) { Rails.root.join('spec/fixtures/payloads/cnous/student_scholarship_valid_response.json').read }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          nom: 'Martin',
          prenom: 'Jerome',
          prenom2: 'Francis',
          dateNaissance: '1980-11-14',
          lieuNaissance: 'La Crèche',
          sexe: 'M',
          boursier: true,
          echelonBourse: '5',
          email: 'francislalanne@gmail.com',
          dateDeRentree: '2020-09-01',
          dureeVersement: 12,
          statut: 0,
          statutLibelle: 'définitif',
          villeEtudes: 'MONTPELLIER',
          etablissement: 'UFR SCIENCES TECHNOLOG SANTE'
        }
      )
    end
  end
end

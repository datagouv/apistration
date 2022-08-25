RSpec.describe CNOUS::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  # rubocop:disable RSpec/RepeatedExampleGroupBody
  context 'when it is from a call with ine param' do
    let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json')) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            nom: 'Martin',
            prenom: 'Jerome',
            prenom2: 'Francis', # rubocop:disable Naming/VariableNumber
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

  context 'when it is from a call with civility param' do
    let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/cnous_student_scholarship_valid_response.json')) }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            nom: 'Martin',
            prenom: 'Jerome',
            prenom2: 'Francis', # rubocop:disable Naming/VariableNumber
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
  # rubocop:enable RSpec/RepeatedExampleGroupBody
end

RSpec.describe MESRI::StudentStatusWithINE::BuildResource, type: :buils_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  let(:body) { File.read(Rails.root.join('spec/fixtures/payloads/mesri_student_status_with_ine_valid_response.json')) }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { instance.bundled_data.data.to_h }

    it do
      expect(subject).to eq(
        {
          ine: '1234567890G',
          nom: 'Dupont',
          prenom: 'Jean',
          dateNaissance: '2000-01-01',
          inscriptions: [
            {
              statut: 'inscrit',
              regime: 'formation initiale',
              dateDebutInscription: '2020-07-01',
              dateFinInscription: '2021-08-31',
              codeCommune: '75113',
              etablissement: {
                uai: '0751967F',
                nomEtablissement: 'UFR ECONOMIE UNIVERSITE PARIS 1 (75634)'
              }
            }
          ]
        }
      )
    end
  end
end

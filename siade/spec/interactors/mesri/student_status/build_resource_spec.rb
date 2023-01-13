RSpec.describe MESRI::StudentStatus::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  context 'when it is from a call with ine param' do
    let(:body) { Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_ine_valid_response.json').read }

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

  context 'when it is from a call with civility params' do
    let(:body) { Rails.root.join('spec/fixtures/payloads/mesri/student_status/with_civility_valid_response.json').read }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            ine: nil,
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
end

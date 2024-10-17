RSpec.describe MESRI::StudentStatus::BuildResource, type: :build_resource do
  subject { instance }

  let(:instance) { described_class.call(response:) }

  let(:response) do
    instance_double(Net::HTTPOK, body:)
  end

  context 'when it is from a call with ine param' do
    let(:body) { read_payload_file('mesri/student_status/with_ine_valid_response.json') }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            ine: '1234567890G',
            identite: {
              nom_naissance: 'Dupont',
              prenom: 'Jean',
              date_naissance: '2000-01-01'
            },
            admissions: [
              {
                date_debut: '2020-07-01',
                date_fin: '2021-08-31',
                est_inscrit: true,
                regime_formation: 'formation initiale',
                code_formation: 'RF1',
                code_cog_insee_commune: '75113',
                etablissement_etudes: {
                  uai: '0751967F',
                  nom: 'UFR ECONOMIE UNIVERSITE PARIS 1 (75634)'
                }
              }
            ]
          }
        )
      end
    end
  end

  context 'when it is from a call with civility params' do
    let(:body) { read_payload_file('mesri/student_status/with_civility_valid_response.json') }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { instance.bundled_data.data.to_h }

      it do
        expect(subject).to eq(
          {
            ine: nil,
            identite: {
              nom_naissance: 'Dupont',
              prenom: 'Jean',
              date_naissance: '2000-01-01'
            },
            admissions: [
              {
                date_debut: '2020-07-01',
                date_fin: '2021-08-31',
                est_inscrit: true,
                regime_formation: 'formation initiale',
                code_formation: 'RF1',
                code_cog_insee_commune: '75113',
                etablissement_etudes: {
                  uai: '0751967F',
                  nom: 'UFR ECONOMIE UNIVERSITE PARIS 1 (75634)'
                }
              }
            ]
          }
        )
      end
    end
  end
end

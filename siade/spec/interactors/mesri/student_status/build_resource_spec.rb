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
                regime_formation: {
                  libelle: 'formation initiale',
                  code: 'RF1'
                },
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

  context 'when the regime label is known' do
    let(:body) { read_payload_file('mesri/student_status/with_ine_valid_response.json') }

    it 'does not track anything' do
      expect(MonitoringService.instance).not_to receive(:track_with_added_context)

      subject
    end
  end

  context 'when the regime label is unknown' do
    let(:body) do
      payload = JSON.parse(read_payload_file('mesri/student_status/with_ine_valid_response.json'))
      payload['inscriptions'].first['regime'] = 'Formation initiale hors apprentissage'
      payload.to_json
    end

    before do
      allow(MonitoringService.instance).to receive(:track_with_added_context)
    end

    it { is_expected.to be_a_success }

    it 'returns the label with a null code' do
      expect(subject.bundled_data.data.admissions.first[:regime_formation]).to eq(
        libelle: 'Formation initiale hors apprentissage',
        code: nil
      )
    end

    it 'tracks the unknown label' do
      subject

      expect(MonitoringService.instance).to have_received(:track_with_added_context).with(
        'warning',
        '[MESRI] Unknown training regime label',
        { regime: 'Formation initiale hors apprentissage' }
      )
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
                regime_formation: {
                  libelle: 'formation initiale',
                  code: 'RF1'
                },
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

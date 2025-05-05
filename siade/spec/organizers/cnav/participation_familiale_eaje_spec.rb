RSpec.describe CNAV::ParticipationFamilialeEAJE, type: :retriever_organizer do
  subject { described_class.call(params:, operation_id: 'api_particulier_v3_cnav_participation_familiale_eaje_with_civility', recipient:) }

  let(:request_id) { SecureRandom.uuid }
  let(:recipient) { valid_siret }

  let(:params) do
    {
      nom_naissance: 'CHAMPION',
      prenoms: ['JEAN-PASCAL'],
      annee_date_naissance: 1980,
      mois_date_naissance: 6,
      jour_date_naissance: 12,
      sexe_etat_civil: 'M',
      code_cog_insee_commune_naissance: '75101',
      code_cog_insee_pays_naissance: '99100',
      request_id:
    }
  end

  describe 'valid params' do
    before do
      allow(Rails.env).to receive(:staging?).and_return(true)
      allow(MockDataBackend).to receive(:get_response_for).and_return(
        {
          status: '200',
          payload: {
            test: 'lol'
          }
        }
      )
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.mocked_data[:payload]

      expect(resource).to be_present
    end
  end
end

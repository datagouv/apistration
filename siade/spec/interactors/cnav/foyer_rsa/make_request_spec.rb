RSpec.describe CNAV::FoyerRSA::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:, operation_id: 'api_particulier_v3_cnav_foyer_rsa_with_civility') }

    let(:params) do
      {
        nom_naissance: 'Dupont',
        prenoms: %w[jean charlie],
        annee_date_naissance: 2008,
        mois_date_naissance: 1,
        jour_date_naissance: 1,
        code_cog_insee_pays_naissance: '99100',
        sexe_etat_civil: 'M'
      }
    end

    it { is_expected.to be_a_success }

    it 'serves the mocked payload matching the params' do
      expect(subject.mocked_data[:payload].dig('data', 'beneficiaires')).to be_present
    end

    it 'sets the mocked status' do
      expect(subject.status).to eq(200)
    end

    context 'with an unknown allocataire' do
      let(:params) do
        {
          nom_naissance: 'Lefebvre',
          code_cog_insee_pays_naissance: '99100',
          sexe_etat_civil: 'F'
        }
      end

      it 'serves the not found payload' do
        expect(subject.status).to eq(404)
      end
    end

    context 'when outside staging and test environments' do
      before do
        allow(Rails.env).to receive_messages(staging?: false, test?: false)
      end

      it 'raises EndpointNotYetImplemented' do
        expect { subject }.to raise_error(MockedInteractor::EndpointNotYetImplemented)
      end
    end
  end
end

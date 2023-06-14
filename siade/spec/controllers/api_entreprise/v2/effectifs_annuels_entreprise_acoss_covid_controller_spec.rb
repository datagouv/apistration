RSpec.describe APIEntreprise::V2::EffectifsAnnuelsEntrepriseACOSSCovidController, type: :controller do
  let(:token) { yes_jwt }
  let(:siren) { valid_siren }

  it_behaves_like 'unauthorized', :show
  it_behaves_like 'ask_for_mandatory_parameters', :show

  before do
    Timecop.freeze

    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  describe 'show' do
    subject { get :show, params: { siren: siren, token: token }.merge(mandatory_params) }

    describe 'happy path' do
      let(:valid_response) do
        {
          siren: valid_siren,
          annee: (Time.zone.today.year - 1).to_s,
          effectifs_annuel: 56.78.to_s,
        }
      end

      before do
        mock_gip_mds_annuel_effectifs(siren: valid_siren, year: (Time.zone.today.year - 1).to_s)
      end

      it 'returns 200' do
        expect(subject.status).to eq(200)
      end

      it 'has a valid body' do
        expect(subject.body).to eq(valid_response.to_json)
      end
    end

    describe 'when GIP-MDS renders an error' do
      before do
        mock_gip_mds_not_found
      end

      it 'returns 404' do
        expect(subject.status).to eq(404)
      end
    end

    describe 'when GIP-MDS renders only RA effectifs' do
      let(:year) { (Time.zone.today.year - 1).to_s }
      let(:siren) { valid_siren }
      before do
        mock_gip_mds_annuel_effectifs(
          siren:,
          year:,
          body: gip_mds_stubbed_payload_for_annuel(siren:, year:, regime_general_effectifs: nil).to_json
        )
      end

      it 'returns 404' do
        expect(subject.status).to eq(404)
      end
    end
  end
end

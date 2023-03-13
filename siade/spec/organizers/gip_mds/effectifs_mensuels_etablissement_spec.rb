RSpec.describe GIPMDS::EffectifsMensuelsEtablissement, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret: valid_siret,
      year: '2021',
      month: '07'
    }
  end

  before do
    mock_gip_mds_authenticate
  end

  context 'when GIP-MDS returns effectifs' do
    before do
      mock_gip_mds_mensuel_effectifs(siret: valid_siret, year: '2021', month: '07')
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_blank }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end

RSpec.describe GIPMDS::EffectifsAnnuelsEntreprise, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren: valid_siren,
      year: '2020'
    }
  end

  before do
    Timecop.freeze

    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  context 'when GIP-MDS returns effectifs' do
    before do
      mock_gip_mds_annuel_effectifs(siren: valid_siren, year: '2020')
    end

    it { is_expected.to be_a_success }

    its(:errors) { is_expected.to be_blank }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end
end

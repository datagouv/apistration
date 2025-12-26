RSpec.describe GIPMDS::ServiceCivique, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:
    }
  end

  let(:nom_naissance) { 'Dupont' }
  let(:prenoms) { %w[Jean Paul] }
  let(:annee_date_naissance) { 1990 }
  let(:mois_date_naissance) { 6 }
  let(:jour_date_naissance) { 25 }

  before do
    Timecop.freeze(Time.zone.local(2024, 6, 15, 10, 30, 0))
    mock_gip_mds_authenticate
  end

  after do
    Timecop.return
  end

  describe 'happy path with current contract' do
    before do
      stub_request(:get, "#{Siade.credentials[:gip_mds_domain]}/contrats-generique").with(
        query: {
          nom: 'DUPONT',
          prenom: 'Jean',
          dateNaissance: '25061990',
          listeCodeNature: '89',
          dateDebutPeriode: 5.years.ago.to_date.strftime('%Y-%m-%d')
        }
      ).and_return(
        status: 200,
        body: read_payload_file('gip_mds/service_civique/valid.json')
      )
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource with current contract' do
      resource = subject.bundled_data.data

      expect(resource.statut_actuel).to include(contrat_trouve: true)
      expect(resource.statut_passe).to include(contrat_trouve: false)
    end
  end
end

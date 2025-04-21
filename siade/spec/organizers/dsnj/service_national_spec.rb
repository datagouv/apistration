RSpec.describe DSNJ::ServiceNational, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      nom_naissance:,
      prenoms:,
      annee_date_naissance:,
      mois_date_naissance:,
      jour_date_naissance:,
      code_cog_insee_commune_naissance:,
      code_cog_insee_pays_naissance:,
      sexe_etat_civil:
    }
  end

  let(:nom_naissance) { 'Sekiro' }
  let(:prenoms) { %w[Shinobi Wolf] }
  let(:annee_date_naissance) { 2008 }
  let(:mois_date_naissance) { 3 }
  let(:jour_date_naissance) { 22 }
  let(:code_cog_insee_commune_naissance) { '92036' }
  let(:code_cog_insee_pays_naissance) { '99100' }
  let(:sexe_etat_civil) { 'M' }

  before do
    stub_dsnj_service_national_valid
  end

  describe 'happy path' do
    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end
  end

  describe 'when code_cog_insee_pays_naissance is not France' do
    let(:code_cog_insee_pays_naissance) { '11111' }

    it 'removes code_cog_insee_commune_naissance' do
      expect(subject.params[:code_cog_insee_commune_naissance]).to be_nil
    end
  end

  describe 'when code_cog_insee_pays_naissance is France' do
    let(:code_cog_insee_pays_naissance) { '99100' }

    it 'does not remove code_cog_insee_commune_naissance' do
      expect(subject.params[:code_cog_insee_commune_naissance]).to eq(code_cog_insee_commune_naissance)
    end
  end
end

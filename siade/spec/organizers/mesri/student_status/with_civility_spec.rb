RSpec.describe MESRI::StudentStatus::WithCivility, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_naissance:,
        prenoms:,
        annee_date_de_naissance:,
        mois_date_de_naissance:,
        jour_date_de_naissance:,
        code_cog_insee_commune_de_naissance:,
        sexe_etat_civil:,

        token_id: SecureRandom.uuid
      }
    end

    let(:nom_naissance) { 'Dupont' }
    let(:prenoms) { ['Jean'] }
    let(:annee_date_de_naissance) { 2000 }
    let(:mois_date_de_naissance) { 1 }
    let(:jour_date_de_naissance) { 1 }
    let(:code_cog_insee_commune_de_naissance) { 'Paris' }
    let(:sexe_etat_civil) { 'M' }

    describe 'happy path' do
      before do
        stub_mesri_with_civility_valid
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end

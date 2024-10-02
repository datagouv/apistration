RSpec.describe CNOUS::StudentScholarshipWithFranceConnect, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        nom_naissance:,
        prenoms:,
        annee_date_naissance:,
        mois_date_naissance:,
        jour_date_naissance:,
        code_cog_commune_naissance:,
        sexe_etat_civil:
      }
    end

    let(:nom_naissance) { 'Dupont' }
    let(:prenoms) { %w[Jean Charlie] }
    let(:birth_date) { '2000-01-01' }
    let(:annee_date_naissance) { 2000 }
    let(:mois_date_naissance) { 1 }
    let(:jour_date_naissance) { 1 }
    let(:code_cog_commune_naissance) { 'Paris' }
    let(:sexe_etat_civil) { 'M' }

    describe 'happy path' do
      before do
        mock_cnous_authenticate
        mock_cnous_valid_call('france_connect')
      end

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
